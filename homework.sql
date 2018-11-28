-- 1.Select the last name of all employees.
SELECT last_name FROM employees;

-- 2. Select the last name of all employees, without duplicates.
SELECT distinct(last_name) FROM employees;

-- 3. Select all the data of employees whose last name is "Smith".
SELECT * FROM employees WHERE last_name = "Smeets";

-- 4.Select all the data of employees whose last name is "Smith" or "Doe".
SELECT * FROM employees WHERE last_name = "Doe" OR last_name = "Smeets";

-- 5.Select all the data of employees that work in department 4.
SELECT e.*
FROM employees e
	JOIN dept_emp de on e.emp_no = de.emp_no
WHERE de.dept_no = 'd004' and de.to_date > curdate();

-- 6.Select all the data of employees that work in department 3 or department 7.
SELECT e.*, de.dept_no
FROM employees e
	JOIN dept_emp de ON e.emp_no = de.emp_no
WHERE (de.dept_no = 'd004' OR de.dept_no = 'd003')
	AND de.to_date > curdate()
ORDER BY e.first_name ASC;

-- 7.Select all the data of employees whose last name begins with an "S".
SELECT * FROM employees WHERE last_name LIKE 'S%';

-- 8.Select the sum of all the departments' salary budget and the salary budgets for each department in one query.
-- todo tomorrow
SELECT SUM(s.salary)
FROM salaries s;
WHERE s.from_date < '1995-01-01' AND s.to_date;

-- 9. Select the number of employees in each department (you only need to show the department code and the number of employees).
SELECT dept_emp.dept_no, count(*)
FROM employees
  JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
GROUP BY dept_emp.dept_no;

-- 10.Select all the data of employees, including each employee's department's data and the hire date on the current department.
SELECT e.*, d.dept_no, d.dept_name
FROM employees e
  JOIN dept_emp de ON e.emp_no = de.emp_no
  JOIN departments d on de.dept_no = d.dept_no;


-- 11. Select the name and last name of each employee, along with the name and salary budget of the employee's department.
-- Выберите имя и фамилию каждого сотрудника вместе с названием и общим бюджетом зарплат отдела сотрудника.
-- todo NOT JOINING
SELECT e.first_name, d.dept_no, d.dept_name, ns.slr
FROM employees e
  JOIN dept_emp de ON e.emp_no = de.emp_no
  JOIN departments d on de.dept_no = d.dept_no;
  JOIN (SELECT SUM(salary) as slr, de.dept_no as dn
FROM salaries s
  JOIN dept_emp de ON s.emp_no = de.emp_no
WHERE s.from_date > '1990-06-25' AND s.to_date < '1991-01-01'
GROUP BY de.dept_no) AS ns ON ns.dn = de.dept_no;

-- 12. Select the name and last name of employees working for departments with a budget greater than $60,000.
SELECT e.first_name
FROM employees e
  JOIN dept_emp de ON e.emp_no = de.emp_no
  JOIN (SELECT SUM(salary) as slr, de.dept_no as dn
          FROM salaries s
            JOIN dept_emp de ON s.emp_no = de.emp_no
            WHERE s.from_date > '1990-06-25' AND s.to_date < '1991-07-25'
            GROUP BY de.dept_no
            HAVING slr > 60000) AS ns ON ns.dn = de.dept_no;

-- 13. Select the departments with a budget larger than the average budget of all the departments.
SELECT SUM(salary) as slr, de.dept_no as dn
FROM salaries s
  JOIN dept_emp de ON s.emp_no = de.emp_no
WHERE s.from_date > '1990-06-25' AND s.to_date < '1991-07-25'
GROUP BY de.dept_no
HAVING slr > (SELECT AVG(slr)
              FROM(SELECT SUM(salary) as slr
                      FROM salaries s
                        JOIN dept_emp de ON s.emp_no = de.emp_no
                        WHERE s.from_date > '1990-06-25' AND s.to_date < '1991-07-25'
                        GROUP BY de.dept_no) as avg_slr);


-- 14. Select the names of departments with more than two employees.
-- Выберите имена отделов с более чем двумя сотрудниками.
SELECT count(de.emp_no) qnt, de.dept_no
FROM dept_emp de
WHERE de.to_date > CURRENT_DATE()
GROUP BY dept_no
HAVING qnt > 2;


-- Add a new department called " IT department", with departmental code d011. Add employees with specified data. Add department manager if necessary.
-- first_name, last_name, birth_date, gender, salary, position, hire_date
-- Jamal, Donovan, 1960-08-01, M, $12,796, Dept manager, 2000-11-14
-- Blythe, Holmes, 1961-12-01, M, $7,945, Senior, 1999-01-13
-- Raya, Brennan, 1962-06-01, F, $6,657, Senior, 2000-04-07
-- Kelly, Decker, 1954-03-11, F, $9,274, Developer, 2000-12-11
-- Chelsea, Bernard, 1957-09-10, M, $5,377, Senior, 1999-11-08
-- Jelani, Kelly, 1958-09-21, M, $7,726, devOps, 1999-05-23
-- Cairo, Hendricks, 1963-07-14, F, $8,281, Senior, 2000-07-09
-- Noel, Dawson, 1952-12-22, F, $7,449, Junior, 2000-11-14
-- Nathan, Allison, 1956-07-03, M, $9,669, Team leader, 2000-03-31
-- Chelsea, Oneal, 1956-05-06, M, $8,066, Team leader, 2000-09-19
-- Kasimir, Hooper, 1957-08-04, F, $9,326, Junior, 2000-07-09
-- Victor, Knox, 1956-11-01, F, $6,750, Developer, 1998-12-08
-- Kiayada, Davenport, 1954-03-20, M, $6,643, Junior, 1999-09-13
-- Warren, Newton, 1961-06-08, M, $9,001, Team leader, 2000-11-27
-- Alexander, Smith, 1960-02-27, M, $6,538, Senior, 1999-09-03
-- Vernon, Burks, 1953-06-05, F, $5,656, Developer, 2000-12-04
-- Elliott, Castillo, 1956-09-30, M, $8,781, DBA, 2000-06-14
-- Galvin, Hebert, 1960-06-06, M, $8,997, Developer, 1998-12-29
-- Price, Merritt, 1955-12-12, F, $9,310, Developer, 2000-06-07
-- Ira, Williams, 1954-05-09, F, $5,173, Senior, 2000-07-18
-- Добавьте новый отдел под названием «IT department» и кодом подразделения d011. Добавьте в этот отдел 20 сотрудников со следующими атрибутами. Назначьте соответствующего сотрудника начальником отдела.
-- first_name, last_name, birth_date, gender, salary, position, hire_date
-- Jamal, Donovan, 1960-08-01, M, $12,796, Dept manager, 2000-11-14
-- Blythe, Holmes, 1961-12-01, M, $7,945, Senior, 1999-01-13
-- Raya, Brennan, 1962-06-01, F, $6,657, Senior, 2000-04-07
-- Kelly, Decker, 1954-03-11, F, $9,274, Developer, 2000-12-11
-- Chelsea, Bernard, 1957-09-10, M, $5,377, Senior, 1999-11-08
-- Jelani, Kelly, 1958-09-21, M, $7,726, devOps, 1999-05-23
-- Cairo, Hendricks, 1963-07-14, F, $8,281, Senior, 2000-07-09
-- Noel, Dawson, 1952-12-22, F, $7,449, Junior, 2000-11-14
-- Nathan, Allison, 1956-07-03, M, $9,669, Team leader, 2000-03-31
-- Chelsea, Oneal, 1956-05-06, M, $8,066, Team leader, 2000-09-19
-- Kasimir, Hooper, 1957-08-04, F, $9,326, Junior, 2000-07-09
-- Victor, Knox, 1956-11-01, F, $6,750, Developer, 1998-12-08
-- Kiayada, Davenport, 1954-03-20, M, $6,643, Junior, 1999-09-13
-- Warren, Newton, 1961-06-08, M, $9,001, Team leader, 2000-11-27
-- Alexander, Smith, 1960-02-27, M, $6,538, Senior, 1999-09-03
-- Vernon, Burks, 1953-06-05, F, $5,656, Developer, 2000-12-04
-- Elliott, Castillo, 1956-09-30, M, $8,781, DBA, 2000-06-14
-- Galvin, Hebert, 1960-06-06, M, $8,997, Developer, 1998-12-29
-- Price, Merritt, 1955-12-12, F, $9,310, Developer, 2000-06-07
-- Ira, Williams, 1954-05-09, F, $5,173, Senior, 2000-07-18
--
--
-- Select the name and last name of employees working for departments with second lowest budget.
-- Выберите имя и фамилию сотрудников, работающих в отделах, со вторым самым низким бюджетом по зарплатам.
-- Select reduced by 10% salary budget for each department.
-- Выведите информацию по зарплатным бюджетам по отделам, сокращенным на 10%.
-- Increase the salary of employees in Marketing, Finance and Sales departments by 10%
-- Увеличьте зарплату сотрудников следующих отделов: «Marketing», «Finance», «Sales»
-- Reassign all employees from the Research department (code d008) to the IT department (code d011). Ex-head of Research department will became the new IT department manager
-- Переведите всех сотрудников из отдела исследований (код d008) в ИТ-отдел (код d011). Учтите, что в IT-отделе новым руководителем станет бывший глава департамента исследований.
-- Delete from the table all employees in the IT department (code d011).
-- Удалите из таблицы всех сотрудников ИТ-отдела (код d011).
-- Delete from the table all employees who work in departments with a salary budget greater than or equal to $60,000.
-- Удалите из таблицы всех сотрудников, которые работают в отделах с бюджетом зарплат, превышающим или равным 60 000 долларов США.
-- List the full names of managers and workers under each one. Replace NULL value in ‘Manager’ column with words “No manager”
-- Перечислить полные имена всех менеджеров и их подчиненных. Вместо значения NULL для столбца ‘Manager’ вывести слова “No manager”
-- Provide the log report of salary budget changes by quarters of the year starting since the first hire date and till the last hire date. Report must consist of department name, quarter number, year, amount of salary budget and average salary value for each department.
-- Выведите данные по ежеквартальному изменению зарплатных бюджетов отделов в период с даты приема на работу первого сотрудника и до даты приема на работу последнего. Отчет должен содержать название отдела, номер квартала в году, номер года, величину зарплатного бюджета отдела и размер средней зарплаты сотрудника отдела.
-- Select the number of inner reassignments for each department sorted in descending order
-- Выведите список отделов с подсчитанным количеством внутренних переходов в каждый отдел из других, отсортированный в обратном порядке.
--
