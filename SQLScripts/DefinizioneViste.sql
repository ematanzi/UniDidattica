-- views definition

CREATE OR REPLACE VIEW COURSEENROLLMENTVIEW AS 
  SELECT 
    DEREF(c.DegreeProgram).DegreeName AS DegreeProgramName,  
    c.CourseCode,                                             
    c.CourseTitle,                                            
    c.Credits,                                                
    COUNT(e.Student) AS NumberOfEnrollments                   
FROM 
    Course c
LEFT JOIN 
    Enrollment e
    ON e.Course = REF(c)                                      
GROUP BY 
    DEREF(c.DegreeProgram).DegreeName,                        
    c.CourseCode,                                             
    c.CourseTitle,                                           
    c.Credits                                               
ORDER BY 
    DEREF(c.DegreeProgram).DegreeName,                      
    c.CourseCode;



CREATE OR REPLACE VIEW DEGREEPROGRAMVIEW AS 
  SELECT deref(dp.department).DeptName AS department, dp.DegreeName AS DegreeName, dp.RequiredCredits AS Credits, dp.InternshipHours AS InternshipHours
FROM DegreeProgram dp;




CREATE OR REPLACE VIEW DEPARTMENTOFSTAFFERVIEW AS 
  SELECT deref(department).deptname AS Department, staffemail as s_email, staffpassword as s_password
FROM staff;




CREATE OR REPLACE VIEW DEPARTMENTREFVIEW AS 
  SELECT REF(d) as department, d.deptname from department d;




CREATE OR REPLACE VIEW ENROLLMENTSOFSTUDENTVIEW AS 
  SELECT  deref(student).email AS email, 
        deref(course).coursecode AS code, 
        deref(course).coursetitle AS title, 
        deref(course).credits AS credits
FROM enrollment;




CREATE OR REPLACE VIEW EXAMSBYSTUDENTVIEW ("EMAIL", "CODE", "TITLE", "EXAM_DATE", "MARK", "ACCEPTED") AS 
  SELECT  deref(en.student).email AS email,
        deref(en.course).coursecode AS code,
        deref(en.course).coursetitle AS title, 
        ex.examdate AS exam_date, 
        ex.mark AS mark, 
        en.exampassed AS accepted
FROM exam ex, enrollment en
WHERE ex.enroll = ref(en);




CREATE OR REPLACE VIEW PRINTNOTACTIVESTUDENTVIEW AS 
  SELECT 
    deref(e.student).matriculation AS Matriculation,
    deref(e.student).firstname AS FirstName,
    deref(e.student).lastname AS LastName,
    deref(e.course).CourseCode AS CourseCode,
    deref(e.course).CourseTitle AS CourseTitle
FROM 
    Enrollment e
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM Exam ex
        WHERE ex.enroll = REF(e)
    )
    AND NOT EXISTS (
        SELECT 1 
        FROM Assignment a
        WHERE a.enroll = REF(e)
    );



CREATE OR REPLACE VIEW PRINTNOTENROLLEDSTUDENTEXAMSVIEW AS 
  SELECT 
    s.matriculation AS Matriculation,
    s.firstname AS FirstName,
    s.lastname AS LastName,
    ex.examdate AS ExamDate,
    ex.mark AS Mark
FROM 
    Student s
JOIN 
    Enrollment e ON DEREF(e.student).matriculation = s.matriculation
JOIN 
    Exam ex ON ex.enroll = REF(e)
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM Tuition t
        WHERE DEREF(t.student).matriculation = s.matriculation
        AND t.expiration > TO_DATE('22-set-2023', 'DD-MON-YYYY')
    );



CREATE OR REPLACE VIEW PRINTSTUDENTINCOMPLIANCEVIEW AS 
  SELECT 
        deref(t.student).matriculation AS Matriculation,
        deref(t.student).firstname AS FirstName,
        deref(t.student).lastname AS LastName,
        t.amount AS Amount,
        t.expiration AS Expiration
    FROM Tuition t
    WHERE t.expiration > SYSDATE AND t.paid = 't';



CREATE OR REPLACE VIEW STUDENTCREDENTIALSVIEW AS 
  SELECT s.email AS email, a.studentpassword AS password FROM student s, studentaccount a
WHERE a.student = ref(s);



CREATE OR REPLACE VIEW STUDENTTUITIONSVIEW AS 
  SELECT  deref(student).email AS email, 
        deref(degreeprogram).degreename AS degree, 
        expiration, 
        amount, 
        paid
FROM tuition;





