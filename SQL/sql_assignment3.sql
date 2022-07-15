/*This is the 3nd week's SQL study (readings: Chapters 2, 7, focusing on join, left outer join, view and sub-query strategies.
Formulate the following queries. You must copy each query question in your submission even you do not have an answer to it.*/

/*1  create a view called "high_load_employee" that shows the ID and the name of employees who work on more than 3 projects.  
Also include employees' total working hours, and total projects, and his/her salary. Show the code of view create statement 
and use select  statement to show the contents of the view.*/

Create or Replace view high_load_employee
as
select e.empid, name, salary, sum(hours) hours, count(pid) projects
from employee e
join workon w
on e.empid = w.empid
group by e.empid, name, salary
having count(pid) > 3
order by e.empid

select * from high_load_employee
 
/*2. List the name of EACH employee in accounting division and the total number of projects the employee works on, as 
well as the total hours he/she spent on the project(s)*/

select name, sum(hours) hours, count(pid) projects
from division d
join employee e
on d.did = e.did
left join workon w
on e.empid = w.empid
where dname = 'accounting'
group by name
 
/*3. List the name of project that ‘Chen’ works on but 'Mary' does not work on. (hint: need two inner select statements /sub-queries, use key word 'IN' and 'NOT IN')
NOTE: There is no employee named ‘Mary’. The below code is for employee named ‘Marilyn’.*/

select pname
from project p
join workon w
on p.pid = w.pid
join employee e
on w.empid = e.empid
where lower(name) = 'chen' and pname not in (select pname
                                            from project p
                                            join workon w
                                            on p.pid = w.pid
                                            join employee e
                                            on w.empid = e.empid
                                            where lower(name) = 'marilyn')
 
/*4. List the name and budget of the project if its budget is over average budget, together with the average budget in query result.*/

select pname, budget, round((select avg(budget) from project),2) budgetavg
from project
where budget > (select avg(budget) 
                from project)
 
/*5 List the total number of project 'chen' does not works on (must use subquery for this query)*/

select count(pname)
from project p
where pname not in (select distinct pname
                    from project p
                    join workon w
                    on p.pid = w.pid
                    where w.empid = (select distinct empid 
                                     from employee 
                                     where lower(name) = 'chen'))
 
/*6. List the name of employee who work on a project sponsored by  'accounting ' division but does not work on a project 
sponsored by engineering division.*/

select distinct name, d.did, dname
from division d
join project p
on d.did = p.did
join workon w
on w.pid = p.pid
join employee e
on e.empid = w.empid
where lower(dname) = 'accounting' and e.empid not in (select distinct e.empid
                                                   from division d
                                                   join employee e
                                                   on d.did = e.did
                                                   join workon w
                                                   on e.empid = w.empid
                                                   where lower(dname) = 'engineering')
 
/*7. List the name of the project that has most people working in  (hint use a subquery at HAVING clause).*/

select pname, p.pid, count(empid)
from project p
join workon w
on p.pid = w.pid
group by pname, p.pid
having count(empid) >= (select max(count(empid)) 
                        from workon 
                        group by pid)
 
/*8. List the total number of employee whose salary is over company's average salary (subquery) for each division, including 
division name.*/

select d.did, dname, count(empid)
from employee e
join division d
on e.did = d.did
where salary > (select avg(salary) 
                from employee)
group by d.did, dname
order by d.did
 
/*9. List the name of manager (note a manager is an employee whose empid is in division table as managerID) who work on 
project (use subquery)*/

select distinct e.name, e.empid
from division d
join employee e
on d.managerid = e.empid
where empid in (select empid 
                from workon)
 
/*10. List the name of employees who don't work on project "web development"  (Must use subquery. Also you need to write 
an explanation on why the JOIN operation does not work for this query).*/
  
/*Note: Join operation does not work for this query because a join operation 
would still output the names of the employees that work in ‘web development’. 
If they work on multiple projects including ‘web development’ those names would 
display which the query does not call for. Subqueries would allow the system to 
recognize unmatched records for ‘web development’ and filter out those names even if they 
work in a project not named ‘web development’.*/

select distinct e.empid, name
from employee e
where e.empid not in (select e.empid
                  from project p
                  join workon w
                  on w.pid = p.pid
                  join employee e
                  on e.empid = w.empid
                  where lower(pname) = 'web development')
order by empid
 
/*11. create a view named as 'letgo_list' that has the name of employee and his/her salary, who don't work on any project 
but salary is over company's average. Also show employee's division name. Run select statement to show the contents of this view.*/

Create or Replace view letgo_list
as
select empid, name, salary
from employee
where empid not in (select empid 
                    from workon) and salary > (select avg(salary) 
                                               from employee)
select * from letgo_list
 
/*12.  List the name of employee whose salary is higher than ‘Larry ‘.*/

select name, salary
from employee
where salary > (select salary 
                from employee 
                where lower(name) = 'larry')
 
/*13. List name of project whose budget is SECOND lowest, list budget too. (hint, refer to the video lecture).*/

select pname, budget
from project
where budget = (select min(budget) 
                from project 
                where budget != (select min(budget) 
                                 from project))
 
/*14. List the name of project that 'chen' works on but not from chen's division.*/

select pname, p.did
from project p
join workon w
on p.pid = w.pid
join employee e
on e.empid = w.empid
where lower(name) = 'chen' and p.did != (select did 
                                         from employee 
                                         where lower(name) = 'chen')
 
/*15. (Bonus) List the name of employee who make highest salary in his/her division (use co-related subquery) .*/

select did, name, salary
from employee e1
where salary in (select max(salary) 
                 from employee e2 
                 where e1.did = e2.did)
order by did
 
