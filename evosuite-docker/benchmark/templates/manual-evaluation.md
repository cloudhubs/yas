# Manual Evaluation Checklist

## Endpoint Information
- **Endpoint ID**: {endpoint_id}
- **Service**: {service}
- **Method**: {http_method}
- **Path**: {endpoint_path}
- **Controller**: {controller_class}
- **Evaluation Date**: _________________
- **Evaluator**: _________________

## Pre-Evaluation Status
- **Generation Status**: _________________
- **Tests Generated**: _________________
- **Test Methods**: _________________

---

## Semantic Validity Checklist

### 1. Targets the correct endpoint?
Check if generated test methods invoke the correct controller method or URL path.

- [ ] Yes - Tests correctly target the intended endpoint
- [ ] No - Tests target wrong endpoint/method
- [ ] N/A - No tests generated

**Evidence/Notes**:
_______________________________________

### 2. Asserts the expected HTTP status codes?
Check if assertions verify HTTP response codes (200, 201, 404, etc.).

- [ ] Yes - All expected status codes are asserted
- [ ] Partial - Some status codes covered
- [ ] No - No status code assertions
- [ ] N/A - No tests generated

**Status codes found in tests**:
_______________________________________

### 3. Uses the correct comparator in assertions?
Check if assertions use appropriate methods (assertEquals for values, assertNotNull for existence).

- [ ] Yes - Comparators match data types appropriately
- [ ] No - Incorrect comparators used
- [ ] N/A - No tests generated

**Issues found**:
_______________________________________

### 4. Inline with the endpoint scenarios?
Check if tests cover expected use cases (happy path, error cases) for the endpoint.

- [ ] Yes - Tests match expected endpoint behavior
- [ ] Partial - Some scenarios covered
- [ ] No - Tests don't match expected scenarios
- [ ] N/A - No tests generated

**Scenario coverage notes**:
_______________________________________

### 5. Missing URL parameter values?
Check if path variables ({orderId}, {contactsId}) are properly populated.

- [ ] No - All URL parameters are handled correctly
- [ ] Yes - Required parameters are missing/null/empty
- [ ] N/A - No tests generated or no URL parameters

**Missing parameters**:
_______________________________________

### 6. Missing request body?
For POST/PUT/PATCH endpoints, check if request body is provided and valid.

- [ ] No - Request body is provided where needed
- [ ] Yes - Request body missing for POST/PUT/PATCH
- [ ] N/A - No tests generated or GET/DELETE endpoint

**Notes**:
_______________________________________

---

## Semantic Quality Checklist

### 7. Are assertions specific and meaningful?
Check if assertions verify specific values vs just null checks.

- [ ] Yes - Assertions verify specific, meaningful values
- [ ] Partial - Mix of specific and generic assertions
- [ ] No - Only null checks or trivial assertions
- [ ] N/A - No tests generated

**Examples of assertions**:
_______________________________________

### 8. Boundary conditions covered?
Check for tests with null, empty, edge case inputs.

- [ ] Yes - Tests include null, empty, boundary values
- [ ] Partial - Some boundary conditions covered
- [ ] No - No boundary testing
- [ ] N/A - No tests generated

**Boundary tests found**:
_______________________________________

### 9. Verifies authorization decisions?
Check if tests verify 401/403 responses or role-based access.

- [ ] Yes - Tests include authorization verification
- [ ] No - No authorization testing
- [ ] N/A - No tests generated

**Auth-related tests**:
_______________________________________

### 10. Invalid URL parameter values?
Check if tests use obviously invalid params (random strings, wrong types).

- [ ] No - All URL parameters appear valid
- [ ] Yes - Contains invalid/random parameter values
- [ ] N/A - No tests generated

**Invalid params found**:
_______________________________________

### 11. Invalid request body?
Check if request body schema matches expected DTO structure.

- [ ] No - Request body is valid/well-formed
- [ ] Yes - Request body is malformed/invalid schema
- [ ] N/A - No tests generated or no request body

**Body issues**:
_______________________________________

---

## Summary Scores

| Category | Score | Max | Notes |
|----------|-------|-----|-------|
| Semantic Validity | __/6 | 6 | Q1-Q6 |
| Semantic Quality | __/5 | 5 | Q7-Q11 |
| **Total** | __/11 | 11 | |

### Scoring Guide
- **Yes**: Full credit (1 point)
- **Partial**: Half credit (0.5 points)
- **No**: No credit (0 points)
- **N/A**: Not counted in total

---

## Overall Assessment

Rate the overall quality of generated tests (if any):

- [ ] High - Tests are comprehensive and meaningful
- [ ] Medium - Tests have some value but need improvement
- [ ] Low - Tests have minimal value
- [ ] N/A - No tests generated

**Comments**:
_______________________________________

---

## Recommendations

What improvements would make these tests more useful?

_______________________________________

---

## Raw Test File Review

If tests were generated, paste relevant code snippets here for reference:

```java
// Paste test code here
```

---

## Evaluation Metadata

- **Time spent on evaluation**: _______ minutes
- **Confidence level**: [ ] High [ ] Medium [ ] Low
- **Additional resources consulted**: _______________________________________
