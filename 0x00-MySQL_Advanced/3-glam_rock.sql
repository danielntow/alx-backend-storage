-- List all bands with Glam rock as their main style, ranked by their longevity
SELECT band_name,
       IFNULL((YEAR(CURDATE()) - SUBSTRING_INDEX(lifespan, '-', 1)), 0) AS lifespan
FROM metal_bands
WHERE styles LIKE '%Glam rock%'
ORDER BY lifespan DESC;
