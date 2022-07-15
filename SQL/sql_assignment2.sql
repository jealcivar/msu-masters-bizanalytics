/*1.	List the total number of projects where some employees who work on it make less than $50k. (hint: You may 
need to use key word  DISTINCT in this query.*/

select count(distinct(pid))
from employee e
join workon w
on e.empid = w.empid
where salary < 50000
 
/*2.	List the total number of employee whose salary is above $40000 for each division,  show division name.*/

select e.did, dname, count(*)
from employee e
join division d
on e.did = d.did
where salary > 40000
group by e.did, dname
order by e.did
 
/*3.	List the total number of project and total budget for each division, show division name .*/

select d.did, sum(budget), count(pid)
from division d
left join project p
on p.did = d.did
group by d.did
order by d.did
 
/*4.	For each project, list its name and total number of employees who work on that project.*/

select p.pid, pname, count(*)
from project p
join workon w
on p.pid = w.pid
group by p.pid, pname
order by p.pid
 
/*5.	List the name and ID of employees that worked on more than one projects. (note :   there are some employees who have same names).*/
 
select e.empid, name, count(pid)
from employee e
join workon w
on e.empid = w.empid
group by e.empid, name
having count(pid) > 1
order by e.empid
 
/*6.	List the name of division that has more than 2 projects whose budget is over 3000.*/

select dname, budget, count(*)
from division d
join project p
on d.did = p.did
where budget > 3000
group by dname, budget
having count(*) > 2
 
/*7.	List the total number of project each employee works on, including employee's name (note :  there are some employees 
who have same names ). */

select e.empid, name, count(pid)
from employee e
left join workon w
on w.empid = e.empid
group by e.empid, name
order by e.empid
 
/*8.	List the total number of employees who work on project 'Web development'.  Also list the total working hours for this project.*/

select pname, sum(hours), count(*)
from workon w
join project p
on w.pid = p.pid
where pname = 'Web development'
group by pname
 
/*9.	List the name of employee and the total number of projects the employee works on, as well as the total hours 
he/she spent on the project(s) (Hint: use left outer join so that employees who don't work on project will be also 
listed with zero project count).*/

select e.empid, name, sum(hours), count(pid)
from employee e
left join workon w
on w.empid = e.empid
group by e.empid, name
order by e.empid
 
/*10.	List the name of project that 'chen' works on. ( Hint: join three tables)*/

select pname, name
from workon w
join project p
on w.pid = p.pid
join employee e
on w.empid = e.empid
where lower(name) = 'chen'
 
/*11.	List the name of manager who work on some projects.*/

select distinct e.name, w.empid
from division d
join employee e
on d.managerid = e.empid
join workon w
on e.empid = w.empid
 
/*12.	List the total number of project and total budget for each division, including division name 
(use left outer join because some division may not have any project).*/

select d.did, dname, sum(budget), count(pid)
from division d
left outer join project p
on p.did = d.did
group by d.did, dname
order by d.did
 
/*13.	 List the name of employee and his/her salary, who work on any project and salary is over $45000. 
(note:  don't duplicate an employee in the list)*/

select distinct(e.empid), name, salary
from employee e
join workon w
on e.empid = w.empid
where salary > 45000
order by e.empid
 
/*14.	List the name of the employee who work on one or more projects with budget over $5000. (note:  don't 
duplicate an employee in the list)*/

select e.empid, name, count(*)
from employee e
join workon w
on e.empid = w.empid
join project p
on p.pid = w.pid
where budget > 5000
group by e.empid, name
having count(*) >= 1
order by e.empid
 
/*15.	List the names that are common among employees. Note, This questoin was in assignment 7 but you must use 
different approach than the one used in assignment 7. (hint: watch the end of recorded Zoom meeting for the last 
query discussed).*/

select e2.name, count(e2.name)
from employee e1
join employee e2
on e1.empid = e2.empid
group by e2.name
having count(e2.name) > 1
 
/*16.	(Bonus, 1 point)  List the name of employee whose salary is over company's average salary (hint: use sub-query)*/

select name, salary
from employee
where salary > (select avg(salary) from employee)
order by salary
 
