# EvoSuite Benchmark Summary Report

## Benchmark Information
- **Timestamp**: 2026-03-21T20:44:10Z
- **Total Endpoints**: 10
- **Runs per Endpoint**: 3
- **Total Runs**: 30
- **Search Budget**: 120s per run
- **Total Duration**: 328s

## Results Summary
- **Successful Generations**: 0
- **Failed Generations**: 30
- **Success Rate**: 0%

## Expected Behavior

Due to EvoSuite's RMI serialization boundary limitation, all controller endpoints
are expected to fail test generation. This is a documented architectural constraint
where Spring framework types (HttpEntity, ResponseEntity, HttpHeaders) cannot be
serialized across the RMI boundary between EvoSuite's master and client processes.

**Expected Error**: `NoClassDefFoundError: org/springframework/http/HttpEntity`

## Output Files

| File | Description |
|------|-------------|
| `benchmark-results.csv` | Main research data (all metrics) |
| `endpoint_XX/run_YY/` | Per-run detailed logs and metrics |
| `endpoint_XX/manual-evaluation.md` | Manual evaluation checklist |

## Next Steps

1. Review `benchmark-results.csv` for automated metrics
2. Complete manual evaluation checklists for any generated tests
3. Run `generate-report.sh` to finalize CSV with manual evaluations
4. Import CSV into statistical analysis software for research paper

## Notes

_Add any observations or notes about this benchmark run here._

