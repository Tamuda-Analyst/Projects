-- EXPLORATORY DATA ANALYSIS

SELECT MAX(total_laid_off), MAX(percentage_laid_off) 
FROM layoffs_staging2;

Select *
From layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT distinct percentage_laid_off
From layoffs_staging2
ORDER BY 1;

Select *
From layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

Select company, SUM(total_laid_off)
From layoffs_staging2
GROUP by company
ORDER By 2 DESC;

Select min(`date`), max(`date`)
From layoffs_staging2;

Select industry, SUM(total_laid_off)
From layoffs_staging2
GROUP by industry
ORDER By 2 DESC;

Select country, SUM(total_laid_off)
From layoffs_staging2
GROUP by country
ORDER By 2 DESC;

Select YEAR(`date`), SUM(total_laid_off)
From layoffs_staging2
GROUP by YEAR(`date`)
ORDER By 1;

Select stage, SUM(total_laid_off)
From layoffs_staging2
GROUP by stage
ORDER By 2 DESC;

Select SUBSTRING(`date`,6,2) as `Month`
From layoffs_staging2;

Select SUBSTRING(`date`,1,7) as `Month`, SUM(total_laid_off)
From layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
Group by `month`
order by 1;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) as `Month`, SUM(total_laid_off) AS total_Off
FROM layoffs_staging2
GROUP BY `month`
ORDER BY 1 ASC
)
Select `Month`, total_off,
SUM(total_off) Over(order by `Month` ) AS Rolling_Total
FROM Rolling_Total;

DELETE
From layoffs_staging2
WHERE `date` IS NULL;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`DATE`)
ORDER BY 3 DESC;

WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`DATE`)
),
Company_Ranking AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking
) 
SELECT *
FROM Company_Ranking
WHERE Ranking <= 5;

































