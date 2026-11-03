SELECT stage, status, checksum
FROM stage_result
WHERE id IN (
  SELECT MAX(id) FROM stage_result GROUP BY stage
)
ORDER BY stage;
