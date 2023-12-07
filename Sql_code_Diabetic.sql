--Average Stay
select time_in_hospital,count(*) as No_of_Patients from [dbo].[diabetic_data]
group by time_in_hospital
order by time_in_hospital ASC
--Medical Specialties based on their AVG Procedures
SELECT DISTINCT(medical_specialty),round(AVG(num_procedures),2) as average_num,COUNT(medical_specialty) AS Num_of_Patients FROM [dbo].[diabetic_data]
GROUP BY medical_specialty
having COUNT(medical_specialty) >50 and round(AVG(num_procedures),1) >1
order by average_num desc
--Race/ethnicity factor:
SELECT DISTINCT race, ROUND(AVG(num_lab_procedures), 2) AS average_lab_procedures
FROM [dbo].[diabetic_data]
GROUP BY race;
--Correlation between # of Lab Procedures and # of days in Hospital:
SELECT
    AVG(time_in_hospital) AS average_days,
    lab_freq
FROM (
    SELECT
        time_in_hospital,
        CASE
            WHEN num_lab_procedures >= 0 AND num_lab_procedures < 33 THEN 'Few'
            WHEN num_lab_procedures >= 33 AND num_lab_procedures < 66 THEN 'Average'
            ELSE 'High'
        END AS lab_freq
    FROM
        [dbo].[diabetic_data]
) AS subquery
GROUP BY
    lab_freq
ORDER BY
    average_days;
--Patient demographics and diabetic medicine:
select patient_nbr from [dbo].[diabetic_data] where race='AfricanAmerican' and metformin='Up'
--Success Hospitals:
create view avg_time as 
select avg(time_in_hospital) as average_time from [dbo].[diabetic_data]
select * from avg_time

with avg_times as (select avg(time_in_hospital) as average_time from [dbo].[diabetic_data])
select patient_nbr FROM [dbo].[diabetic_data] WHERE admission_type_id = 1 AND time_in_hospital <= (select * from avg_times)
--Summary of Patients:

select top 50 CONCAT('Patient',' ',patient_nbr,'was', race,'and',
(case when readmitted = 'No' then 'was not readmitted.' else 'was admitted.' end),
'They had', num_medications,'medications','and',num_lab_procedures,'lab procedures') as summary
from [dbo].[diabetic_data]
order by num_medications desc , num_lab_procedures desc


