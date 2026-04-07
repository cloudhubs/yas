BEGIN {
    OFS = ","
    RS = "\0"
}

function csv_escape(value, escaped) {
    escaped = value
    gsub(/\r/, "", escaped)
    gsub(/"/, "\"\"", escaped)
    return "\"" escaped "\""
}

function trim(value) {
    sub(/^[[:space:]]+/, "", value)
    sub(/[[:space:]]+$/, "", value)
    return value
}

function get_file_type(file_name, lowered) {
    lowered = tolower(file_name)
    if (lowered ~ /faults/) return "faults"
    if (lowered ~ /successes/) return "successes"
    if (lowered ~ /others/) return "others"
    return "unknown"
}

function get_class_name(content, match_data) {
    if (match(content, /(^|[\r\n])[[:space:]]*public[[:space:]]+class[[:space:]]+([A-Za-z0-9_]+)/, match_data)) {
        return match_data[2]
    }
    if (match(content, /^[[:space:]]*public[[:space:]]+class[[:space:]]+([A-Za-z0-9_]+)/, match_data)) {
        return match_data[1]
    }
    return ""
}

function extract_endpoint_from_comment(comment, match_data, verb, endpoint) {
    if (match(comment, /\([0-9]+\)[[:space:]]+([A-Z]+):([^[:space:]\r\n*]+)/, match_data)) {
        verb = match_data[1]
        endpoint = match_data[2]
        return verb SUBSEP endpoint
    }
    return SUBSEP
}

function extract_endpoint_from_body(body, match_data, verb, endpoint) {
    if (match(body, /\.(get|post|put|patch|delete)\([[:space:]]*baseUrlOfSut[[:space:]]*\+[[:space:]]*"([^"]+)"/, match_data)) {
        verb = toupper(match_data[1])
        endpoint = match_data[2]
        return verb SUBSEP endpoint
    }
    return SUBSEP
}

function get_asserted_status_code(body, result, seen, match_data, remainder, code) {
    result = ""
    delete seen
    remainder = body

    while (match(remainder, /\.statusCode\(([0-9]+)\)/, match_data)) {
        code = match_data[1]
        if (!(code in seen)) {
            seen[code] = 1
            result = (result == "" ? code : result ";" code)
        }
        remainder = substr(remainder, RSTART + RLENGTH)
    }

    return result
}

function get_assert_count(body, assertion_body, count, match_data, remainder) {
    count = 0
    assertion_body = body
    if (index(body, ".then()") > 0) {
        assertion_body = substr(body, index(body, ".then()"))
    }

    remainder = assertion_body
    while (match(remainder, /\.(statusCode|body|header|headers|contentType|statusLine|time|cookie|cookies)\(/, match_data)) {
        count++
        remainder = substr(remainder, RSTART + RLENGTH)
    }

    return count
}

function print_row(service, profile, file_name, class_name, method_name, endpoint, http, asserted_code, assert_count, file_type, file_path) {
    print csv_escape(service), csv_escape(profile), csv_escape(file_name), csv_escape(class_name), csv_escape(method_name), csv_escape(endpoint), csv_escape(http), csv_escape(asserted_code), csv_escape(assert_count), csv_escape(file_type), csv_escape(file_path)
}

function flush_method(file_name, class_name, service, profile, file_type, file_path, comment, method_name, body, endpoint_info, verb, endpoint, asserted_code, assert_count) {
    if (method_name == "") {
        return
    }

    endpoint_info = extract_endpoint_from_comment(comment)
    split(endpoint_info, parts, SUBSEP)
    verb = parts[1]
    endpoint = parts[2]

    if (verb == "" || endpoint == "") {
        endpoint_info = extract_endpoint_from_body(body)
        split(endpoint_info, parts, SUBSEP)
        verb = parts[1]
        endpoint = parts[2]
    }

    asserted_code = get_asserted_status_code(body)
    assert_count = get_assert_count(body)
    print_row(service, profile, file_name, class_name, method_name, endpoint, verb, asserted_code, assert_count, file_type, file_path)
}

{
    line_count = split($0, lines, /\n/)
    content = $0
    class_name = get_class_name(content)
    file_type = get_file_type(FILE_NAME)

    relative_path = FILE_RELATIVE_PATH
    gsub(/\\/, "/", relative_path)
    path_count = split(relative_path, path_parts, "/")
    service = path_count >= 1 ? path_parts[1] : ""
    profile = path_count >= 2 ? path_parts[2] : ""

    has_methods = 0
    comment = ""
    pending_comment = ""

    for (i = 1; i <= line_count; i++) {
        line = lines[i]

        if (line ~ /^[[:space:]]*\/\*\*/) {
            pending_comment = line "\n"
            while (i < line_count && lines[i] !~ /\*\//) {
                i++
                pending_comment = pending_comment lines[i] "\n"
            }
            continue
        }

        if (line ~ /^[[:space:]]*@/) {
            annotation_block = line "\n"
            while (i + 1 <= line_count && lines[i + 1] ~ /^[[:space:]]*@/) {
                i++
                annotation_block = annotation_block lines[i] "\n"
            }

            method_line = ""
            if (i + 1 <= line_count) {
                method_line = lines[i + 1]
            }

            if (match(method_line, /^[[:space:]]*public[[:space:]]+void[[:space:]]+([A-Za-z0-9_]+)[[:space:]]*\(\)[[:space:]]*throws[[:space:]]+Exception[[:space:]]*\{/, method_match)) {
                has_methods = 1
                method_name = method_match[1]
                comment = pending_comment
                pending_comment = ""
                i++

                body = ""
                while (i + 1 <= line_count) {
                    i++
                    if (lines[i] ~ /^[[:space:]]*\}/) {
                        break
                    }
                    body = body lines[i] "\n"
                }

                flush_method(FILE_NAME, class_name, service, profile, file_type, FILE_PATH, comment, method_name, body)
                comment = ""
                continue
            }
        }

        if (trim(line) != "") {
            pending_comment = ""
        }
    }

    if (!has_methods) {
        print_row(service, profile, FILE_NAME, class_name, "", "", "", "", 0, file_type, FILE_PATH)
    }
}
