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


