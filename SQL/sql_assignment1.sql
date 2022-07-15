/*Division (DID, dname, managerID)
Employee (empID, name, salary, DID)
Project (PID, pname, budget, DID)
Workon (PID, EmpID, hours)

Formulate the following queries*/

/*1.	List the name and salary of employees who don't work for division 3.
(Note: this code includes the DID in SELECT for confirmation.)*/

select name, salary, did
from employee
where did != 3
order by did
 
/*2.	List the name of project from division 1 whose budget is between 5000-7000
(Note: this code includes the DID in SELECT for confirmation.)*/

select pname, budget, did
from project
where budget between 5000 and 7000 and did = 1
 
/*3.	List the total number of employee whose name has 'a' as the second letter from right (hint, using 
keyword LIKE and wildcard character)*/

select count(*)
from employee
where name like '%a_'
 
/*4.	List the total number of employee whose initial of name is NOT 's' for each division, including division ID
(Note: this code includes lower() which searches for all names beginning in ‘s’ while making all initials lower case.)*/

select did, count(*)
from employee
where lower(name) not like 's%' 
group by did
order by did
 
/*5.	List the total project budget for each division, including division ID.*/

select did, sum(budget)
from project
group by did
order by did
 
/*6.	List the ID of the division that has two or more projects with budget over $6000.
(Note: this code includes the # of projects and budget sum in SELECT for confirmation.)*/

select did, count(*), sum(budget)
from project
group by did
having count(*) >= 2 and sum(budget) > 6000
order by did
 
/*7.	List the ID of division that sponsors project "Web development", List the project budget too. (hint: use function Upper () or Lower() to convert case of letters to facilitate the comparison. 
(Note: this code includes the Pname in SELECT for confirmation.)*/

select did, budget, pname
from project
where lower(pname) = 'web development'
 
/*8.	List the total number of employee whose salary is above $40000 for each division, list division ID.*/

select did, count(*)
from employee
where salary > 40000
group by did
order by did
 
/*9.	List the total number of project and total budget for each division, show division ID*/

select did, count(*), sum(budget)
from project
group by did
order by did
 
/*10.	List the ID of employee that worked on more than three projects.
(Note: this code includes the amount of projects in SELECT for confirmation.)*/

select empid, count(*)
from workon
group by empid
having count(*) > 3
order by empid
 
/*11.	List the ID of each division with its highest salary..*/

select did, max(salary)
from employee
group by did
order by did
 
/*12.	List the total number of project each employee works on, including employee's ID and total hours an employee spent on project.*/

select empid, sum(hours), count(*) as projectcount
from workon
group by empid
order by empid
 
/*13.	List the total number of employees who work on project 1.
(Note: this code includes the PID in SELECT for confirmation.)*/

select pid, count(*)
from workon
where pid = 1
group by pid
 
/*14.	List names that are shared by more than one employee and list the number of employees who share that name.*/

select name, count(*)
from employee
group by name
having count(*) > 1
 
/*15.	List the ID of project that accumulated more than 250 man-hours.
(Note: this code includes the total hours per PID in SELECT for confirmation.)*/

select pid, sum(hours)
from workon
group by pid
having sum(hours) > 250
 
/*16.	Bonus question (1 point) List the total number of employee and total salary for each division, including division name (hint: use JOIN operation, read the text for join operation)
(Note: this code includes the DID in SELECT for confirmation.)*/

select employee.did, dname, count(*), sum(salary)
from employee
join division
on employee.did = division.did
group by employee.did, dname
order by employee.did
 

