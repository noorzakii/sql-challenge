--creating all 6 tables
CREATE TABLE departments (
dept_number VARCHAR(30) NOT NULL,
dept_name VARCHAR(50) NOT NULL,
PRIMARY KEY (dept_number)
);

CREATE TABLE titles (
title_id VARCHAR(25) NOT NULL,
title VARCHAR(40) NOT NULL,
PRIMARY KEY (title_id)
);

CREATE TABLE employees (
	employee_number INTEGER NOT NULL,
	employee_title_id VARCHAR(20) NOT NULL,
	hire_date DATE NOT NULL,
	sex VARCHAR(10) NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	PRIMARY KEY (employee_number),
	FOREIGN KEY (employee_title_id) REFERENCES titles (title_id)
);

CREATE TABLE dept_manager(
dept_number VARCHAR(10) NOT NULL,
employee_number INTEGER NOT NULL,
PRIMARY KEY (dept_number,employee_number),
FOREIGN KEY (dept_number) REFERENCES departments (dept_number),
FOREIGN KEY (employee_number) REFERENCES employees (employee_number)
);

CREATE TABLE dept_employee (
employee_number INTEGER NOT NULL,
dept_number VARCHAR(20) NOT NULL,
PRIMARY KEY (employee_number, dept_number),
FOREIGN KEY (employee_number) REFERENCES employees (employee_number),
FOREIGN KEY (dept_number) REFERENCES departments (dept_number)
);

CREATE TABLE salaries (
employee_number INTEGER NOT NULL,
salary BIGINT NOT NULL,
PRIMARY KEY (employee_number),
FOREIGN KEY (employee_number) REFERENCES employees (employee_number)
);

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.employee_number, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
LEFT JOIN salaries s
ON e.employee_number = s.employee_number

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date <= '1986-12-31' AND hire_date >= '1986-01-01'

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT e.first_name, e.last_name, e.employee_number, dm.dept_number, d.dept_name
FROM employees e
INNER JOIN dept_manager dm
ON e.employee_number = dm.employee_number
INNER JOIN departments d
ON dm.dept_number = d.dept_number

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT e.first_name, e.last_name, e.employee_number, de.dept_number, d.dept_name
FROM employees e 
LEFT JOIN dept_employee de
ON e.employee_number = de.employee_number
LEFT JOIN departments d
ON de.dept_number = d.dept_number

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.employee_number, e.first_name, e.last_name
FROM employees e
WHERE e.employee_number IN
(SELECT de.employee_number
FROM dept_employee de
WHERE de.dept_number IN
(SELECT d.dept_number
FROM departments d
WHERE d.dept_name = 'Sales'
))

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.employee_number, e.first_name, e.last_name, d.dept_name
FROM employees e
LEFT JOIN dept_employee de
ON e.employee_number = de.employee_number
LEFT JOIN departments d
ON de.dept_number = d.dept_number
WHERE d.dept_name IN ('Sales', 'Development')

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, Count(last_name) AS frequency
FROM employees
GROUP BY last_name
ORDER BY (frequency) DESC






