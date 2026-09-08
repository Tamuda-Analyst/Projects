-- Data Cleaning

Select *
From layoffs;

-- 1. Remove Duplicates if Any
-- 2. Standardize the Data
-- 3. Null/Blank Values
-- 4. Remove unnecessary rows/columns

Create Table Layoffs_Staging
Like layoffs;

Select *
From layoffs_staging;

INSERT layoffs_staging
Select *
From layoffs;

-- Duplicates
Select *,
Row_number() Over(Partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
From layoffs_staging;

WITH duplicate_cte AS
(
Select *,
Row_number() Over(Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

Select *
From layoffs_staging
WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
From layoffs_staging2;

INSERT INTO layoffs_staging2
Select *,
Row_number() Over(Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging;

Select *
From layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

Select *
From layoffs_staging2;

-- Standardizing Data

Select company, TRIM(company)
From layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry like 'crypto%';

Select *
From layoffs_staging2;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country like 'United States%';

Select *
From layoffs_staging2;

Select `date`
From layoffs_staging2;

Select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
From layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY `date` DATE;

-- NULL AND BLANK VALUES

Select *
From layoffs_staging2;

Select *
From layoffs_staging2
WHERE total_laid_off IS NULL;

Select *
From layoffs_staging2
WHERE industry IS NULL
OR industry = '';

Select *
From layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = 'travel'
WHERE company = 'Airbnb';

Select *
From layoffs_staging2
WHERE company = "Bally's Interactive";

Select *
From layoffs_staging2
WHERE company = 'Carvana';

UPDATE layoffs_staging2
SET industry = 'transportation'
WHERE company = 'Carvana';

Select *
From layoffs_staging2
WHERE company = 'Juul';

UPDATE layoffs_staging2
SET industry = 'Consumer'
WHERE company = 'Juul';



Select *
From layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
From layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

Select *
From layoffs_staging2;









