/*Part A.
Formulate the following queries:
0. (new) List ename of employee and his/her ID  who with at least 10 people on same project. */

select distinct e.empid, name
from employee e
join workon w
on e.empid = w.empid
where pid IN (select pid 
              from workon 
              group by pid 
              having count(empid) >= 10)
group by e.empid, name
order by empid
 
/*1,  List the name of project that has MOST of employees working on it. (hint: use group by and having with subquery )*/

select pname, count(empid) headcount
from project p
join workon w
on p.pid = w.pid
group by pname
having count(empid) >= (select max(count(empid)) 
                        from workon 
                        group by pid)
 
/*2. List the name of division that has more employees whose salary is above the divisional average salary than any other divisions. */

select d.did, dname
from division d
join employee e
on d.did = e.did
where salary > (select avg(salary) 
                from employee ee 
                where e.did = ee.did)
group by d.did, dname
having count(empid) >=ALL (select count(empid)
                          from employee e
                          where salary > (select avg(salary)
                                          from employee ee
                                          where e.did = ee.did) 
                           group by e.did)
 
/*3. Increase the salary of division manager  by 1% if he/she works on other division's project  (hint: need a co-related condition )*/

update employee
set salary = salary * 1.01
where empid IN (select distinct e.empid
                from division d
                join employee e
                on d.managerid = e.empid
                join workon w
                on w.empid = e.empid
                where pid NOT IN (select pid from project p where p.did = d.did)
                )
 
/*4.  List the total number of employees from Chen's division who work with Chen on project development. (note if a Chen's divisional 
colleague works on more than one projects with Chen, this colleague should be only count once. */

select count(distinct e.empid)
from workon w
join employee e
on w.empid = e.empid
where e.did = (select d.did 
               from division d 
               join employee e 
               on e.did = d.did 
               where lower(name) = 'chen')
and w.pid IN (select w.pid 
              from workon w  
              join employee e
              on e.empid = w.empid
              where lower(name) = 'chen')
and e.empid NOT IN (select e.empid 
                    from workon w 
                    join employee e 
                    on e.empid = w.empid 
                    where lower(name) = 'chen')
 
/*5. For each project, list the name of project, and (1) the total number of employee working on it, (2 )the total number of employees 
who work on  it but from other division (not the division that sponsors this project), and (3) the total number of employee who work 
on it and are from the same division that sponsors this project. Hint, the structure of your code is as follows
Select pname ,
              (a select statement that returns data in (1)) total, 
              ( a select statement  that returns data in (2)) outsiders,
              (a select statement that returns data in (3)) insiders
From Project
Note, this query is to show that a (co-related) subquery can appear at the Select clause. The words total, insiders and outsiders are 
just the given titles/alias for columns of counts returned by subqueries .*/

select pid, pname, (select count(empid) 
                    from workon w 
                    where w.pid = p.pid) Total, (select count(distinct ww.empid)
                                                 from employee e
                                                 join workon ww
                                                 on e.empid = ww.empid
                                                 where e.did != p.did
                                                 and ww.pid = p.pid) Outsiders, (select count(distinct ww.empid)
                                                                                 from employee e
                                                                                 join workon ww
                                                                                 on e.empid = ww.empid
                                                                                 where e.did = p.did
                                                                                 and ww.pid = p.pid) Insiders
from project p 
 

