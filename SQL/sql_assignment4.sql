/*readings: Chapters 2, 7, 8 ( Focus:  correlated subquery)*/

/*Formulate the following queries: (note, for some queries, you may need to use the combination of join and 
subqury or correlated subquery, together with group by and having clauses).*/
 
/*1.	List the name of project sponsored by chen's division. (hint/think: find a project whose DID equals to the 
DID of an employee whose name is chen)*/

select pname
from project p
join division d
on p.did = d.did
where p.did = (select did 
               from employee 
               where name = 'chen')
 
/*2.	List the name of employee who is working on the project whose budget is below the divisional average project 
budget (use correlated subquery).*/

select distinct e.empid, name
from employee e
join workon w
on e.empid = w.empid
where pid in (select pid 
              from project p1 
              where budget < (select avg(budget) 
                              from project p2 
                              where p1.did = p2.did))
order by empid
 
/*3.	List the name of project that some employee(s) who is/are working on it make less than divisional average salary 
(use correlated subquery).*/

select distinct pname, p.pid
from project p
join workon w
on w.pid = p.pid
where empid in (select empid 
                from employee e1 
                where salary < (select avg(salary) 
                                from employee e2 
                                where e1.did = e2.did))
order by pid
 
/*4.	List the total number of division that has 4 or more employees working on projects. For this query I built a framework 
of the code, you just need to fill in the right code in ____ , and then run the code to get the result.*/

select count(did)
from division d
where did in (select e.did 
              from employee e, workon w 
              where e.empid = w.empid 
              group by e.did 
              having count(w.empid) >= 4)
 
/*5.	List the total number of projects 'accounting' division manager works on. (Note, if an employee is a division's manager, 
his/her empID is IN the Division table)*/

select count(pid)
from workon
where empid = (select empid 
               from employee e 
               join division d 
               on d.managerid = e.empid 
               where lower(dname) = 'accounting')
 

/*6.	List the name of the employees (and his/her DID) who work on more projects than his/her divisional colleagues. (hint: 
co-realated subquery, also use having , compare count() to count, use “ … having count (pid) >=ALL (select count (pid) …..)*/

select e.empid, name, e.did, count(pid)
from employee e
join workon w
on w.empid = e.empid
group by e.did, e.empid, name
having count(pid) >=ALL (select count(pid) 
                         from workon ww
                         join employee ee
                         on ww.empid = ee.empid 
                         where ee.did = e.did 
                         group by ee.empid)
order by e.did
 
/*7.	List the name of the division that has more than one employee whose salary is greater than company's  average salary  
(subquery,  group by, having)*/

select d.did, dname, count(empid)
from division d
join employee e
on e.did = d.did
where salary > (select avg(salary) 
                from employee)
group by d.did, dname
having count(empid) > 1
order by did
 
/*8.	List the name of the division that has more than one employee whose salary is greater than the divisional average 
salary  (corelated subquery, group by, having)*/

select d.did, dname, count(empid)
from division d
join employee e
on d.did = e.did
where salary > (select avg(salary) 
                from employee ee 
                where e.did = ee.did)
group by d.did, dname
having count(empid) > 1
order by did
 
/*9.	List the name of the employee that has the lowest salary in his division and list the total number of projects this 
employee is work on  (use corelated subquery)*/

select e1.did, e1.empid, name, salary, count(w.pid) projectcount
from employee e1
left join workon w
on e1.empid = w.empid
where salary = (select min(salary) 
                from employee e2 
                where e1.did = e2.did)
group by e1.did, e1.empid, name, salary
order by e1.did
 

/*10.	List the name of employee in Chen's division who works on a project that Chen does NOT work on.*/

select distinct e.empid, name
from employee e
join workon w
on e.empid = w.empid
where did = (select did 
             from employee 
             where lower(name) = 'chen') and pid not in (select pid 
                                                         from workon 
                                                         where empid = (select empid 
                                                                        from employee 
                                                                        where lower(name) = 'chen'))
 
/*11.	List the name of divisions that sponsors project(s) Chen works on . (Namely, if there is a project 'chen' 
works on, find the name of the division that sponsors that project.)*/

select distinct dname
from division d
join project p
on d.did = p.did
join workon w
on p.pid = w.pid
where empid = (select empid 
               from employee 
               where lower(name) = 'chen')
 
/*12.	List the name of division (d) that has employee who work on a project (p) not sponsored by this division. 
(hint in a corelated subquery where d.did <> p.did)*/ 

select distinct d.did, dname
from division d
join employee e
on e.did = d.did
join workon w
on w.empid = e.empid
where pid in (select pid 
              from project p 
              where d.did != p.did)
order by d.did
 
/*13.	List the name of employee who work with Chen on some project(s).*/

select distinct e.empid, name
from employee e
join workon w
on e.empid = w.empid
where pid in (select pid 
              from workon 
              where empid = (select empid 
                             from employee 
                             where lower(name) = 'chen') and lower(name) != 'chen')
order by empid
 
/*14.	Increase the salary of employees in engineering division by 10% if they work on more than 1 project.*/

update employee
set salary = salary * 1.1
where empid in (select e.empid
                from workon w
                join employee e
                on w.empid = e.empid
                where did = (select did 
                             from division 
                             where lower(dname) = 'engineering')
                group by e.empid
                having count(pid) > 1
                )
 
/*15.	Increase the budget of a project by 10% if it has more than two employees working on it.*/ 

update project
set budget = budget * 1.1
where pid in (select p.pid
              from project p
              join workon w
              on p.pid = w.pid
              group by p.pid
              having count(empid) > 2
              )
 
/*16.	(bonus) List the name of employee who work on all project (hint: Use NOT EXISTS predicate .  
The logic of the code is  to find an employee that there NOT exists a project this employee does NOT 
work on,  Use NOT EXISTS twice, note, there is a very similar query in chapter 8).*/ 

select distinct empid, name
from employee e
where NOT EXISTS (select pid 
                  from project p
                  where NOT EXISTS (select w.pid 
                                    from workon w 
                                    where p.pid = w.pid 
                                    and e.empid = w.empid))
order by empid

 

