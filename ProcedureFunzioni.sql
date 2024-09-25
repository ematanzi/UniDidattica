-- other procedures definition

create or replace PROCEDURE CheckUnpaidTuition (p_matriculation CHAR) IS
    
    CURSOR unpaid_tuition_cur IS
        SELECT t.amount, t.expiration
        FROM Tuition t
        WHERE DEREF(t.student).matriculation = p_matriculation
          AND t.paid = 'f';

    v_amount Tuition.amount%TYPE;
    v_expiration Tuition.expiration%TYPE;

    v_student_exists CHAR(1);

BEGIN

    SELECT COUNT(*)
    INTO v_student_exists
    FROM Student s
    WHERE s.matriculation = p_matriculation;


    IF v_student_exists = 0 THEN
        dbms_output.put_line('Warning: No student found with matriculation ' || p_matriculation);
    ELSE

        OPEN unpaid_tuition_cur;


        LOOP
            FETCH unpaid_tuition_cur INTO v_amount, v_expiration;
            EXIT WHEN unpaid_tuition_cur%NOTFOUND;

            dbms_output.put_line('Unpaid Amount: ' || v_amount || ', Expiration Date: ' || v_expiration);
        END LOOP;


        CLOSE unpaid_tuition_cur;
    END IF;
END;


-- Insertion of a new exam as the average of the Assignments votes for the same course
create or replace PROCEDURE CreateExamForEnrollment (
    studentCode CHAR,
    courseCode CHAR
) AS
    enrollmentRef REF EnrollmentType;
    totalAssignments NUMBER := 0;
    sumMarks NUMBER := 0;
    avgMark NUMBER := 0;
BEGIN
    
    SELECT REF(e)
    INTO enrollmentRef
    FROM Enrollment e
    JOIN Course c ON e.Course = REF(c)
    JOIN Student s ON e.Student = REF(s)
    WHERE s.Matriculation = studentCode
      AND c.CourseCode = courseCode;

    
    SELECT COUNT(a.Mark), SUM(a.Mark)
    INTO totalAssignments, sumMarks
    FROM Assignment a
    WHERE a.Enroll = enrollmentRef;

        IF totalAssignments > 0 THEN
        avgMark := CEIL(sumMarks / totalAssignments);  
    ELSE
        avgMark := 0;  -- Se non ci sono assignment, assegna 0
    END IF;


    INSERT INTO Exam
    VALUES (ExamType(
        enrollmentRef,
        SYSDATE,  -- Data corrente
        avgMark   -- Media dei voti arrotondata
    ));

    DBMS_OUTPUT.PUT_LINE('Nuova riga inserita nella tabella Exam con media: ' || avgMark);
END;



create or replace PROCEDURE DeleteAssociatedEnrollmentsProc(p_matriculation VARCHAR2) IS
BEGIN
    DELETE FROM Enrollment
    WHERE DEREF(student).matriculation = p_matriculation;
END;


create or replace TYPE MatriculationArrayType AS VARRAY(1000) OF CHAR(6);

create or replace PROCEDURE GetMatriculations(p_matriculations OUT MatriculationArrayType) AS
    v_matriculation MatriculationArrayType := MatriculationArrayType();
BEGIN
    
    FOR r IN (SELECT Matriculation FROM Student) LOOP
        
        v_matriculation.EXTEND;
        v_matriculation(v_matriculation.COUNT) := r.Matriculation;
    END LOOP;

    p_matriculations := v_matriculation;
END;



create or replace PROCEDURE GetMatriculationsInf(p_matriculations OUT MatriculationArrayType) AS
    v_matriculation MatriculationArrayType := MatriculationArrayType();
BEGIN

    FOR r IN (
        SELECT s.Matriculation
        FROM Student s
        WHERE DEREF(s.Department).DeptName = 'Informatica'
    ) LOOP

        v_matriculation.EXTEND;
        v_matriculation(v_matriculation.COUNT) := r.Matriculation;
    END LOOP;

    p_matriculations := v_matriculation;
END;


create or replace PROCEDURE GetMatriculationsMed(p_matriculations OUT MatriculationArrayType) AS
    v_matriculation MatriculationArrayType := MatriculationArrayType();
BEGIN
    
    FOR r IN (
        SELECT s.Matriculation
        FROM Student s
        WHERE DEREF(s.Department).DeptName = 'Medicina'
    ) LOOP
        
        v_matriculation.EXTEND;
        v_matriculation(v_matriculation.COUNT) := r.Matriculation;
    END LOOP;

    p_matriculations := v_matriculation;
END;



create or replace FUNCTION GenerateRandomEmail RETURN VARCHAR2 IS
    random_part VARCHAR2(20);
    random_length NUMBER := 8; 
BEGIN
    random_part := SUBSTR(DBMS_RANDOM.STRING('x', random_length), 1, random_length);

    RETURN random_part || '@studenti.unidi';
END;


create or replace FUNCTION GenerateRandomMemberEmail RETURN VARCHAR2 IS
    random_part VARCHAR2(20);
    random_length NUMBER := 8; 
BEGIN
    random_part := SUBSTR(DBMS_RANDOM.STRING('x', random_length), 1, random_length);

    RETURN random_part || '@unidi.it';
END;




create or replace PROCEDURE PrintProfessorWithMostCourses IS
    
    CURSOR professor_cur IS
        SELECT m.matriculation, m.firstname, m.lastname, COUNT(c.CourseCode) AS course_count
        FROM Member m
        JOIN Course c ON DEREF(c.Teacher).matriculation = m.matriculation
        GROUP BY m.matriculation, m.firstname, m.lastname
        ORDER BY course_count DESC
        FETCH FIRST 1 ROWS ONLY;

    
    CURSOR courses_cur (p_matriculation CHAR) IS
        SELECT DEREF(c.DegreeProgram).DegreeName, c.CourseCode, c.CourseTitle
        FROM Course c
        WHERE DEREF(c.Teacher).matriculation = p_matriculation;

    
    v_matriculation Member.matriculation%TYPE;
    v_firstname Member.firstname%TYPE;
    v_lastname Member.lastname%TYPE;

    
    v_degreeName VARCHAR2(30);   
    v_courseCode CHAR(6);        
    v_courseTitle VARCHAR2(30);  

    v_course_count NUMBER; -- Aggiunta della variabile course_count per il cursore professor_cur

BEGIN
    
    OPEN professor_cur;
    FETCH professor_cur INTO v_matriculation, v_firstname, v_lastname, v_course_count; -- Fetch include anche course_count

    IF professor_cur%FOUND THEN

        dbms_output.put_line('Professor: ' || v_firstname || ' ' || v_lastname || ' (Matriculation: ' || v_matriculation || ')');

        
        OPEN courses_cur(v_matriculation);

        
        LOOP
            FETCH courses_cur INTO v_degreeName, v_courseCode, v_courseTitle;
            EXIT WHEN courses_cur%NOTFOUND;

            dbms_output.put_line('Degree Program: ' || v_degreeName || ', Course Code: ' || v_courseCode || ', Course Title: ' || v_courseTitle);
        END LOOP;

        
        CLOSE courses_cur;
    ELSE
        dbms_output.put_line('No professor found.');
    END IF;

    
    CLOSE professor_cur;
END;




create or replace FUNCTION GetResearchProjects
RETURN SYS_REFCURSOR
IS
    proj_cursor SYS_REFCURSOR;
BEGIN
    OPEN proj_cursor FOR
    SELECT r.Title, 
           r.StartDate, 
           r.EndDate, 
           r.ProjectDurationDays()
    FROM ResearchProject r
    ORDER BY r.ProjectDurationDays() DESC;

    RETURN proj_cursor;
END;



create or replace PROCEDURE PrintResearchProjects
IS
    proj_cursor SYS_REFCURSOR;
    v_title VARCHAR2(40);
    v_startdate DATE;
    v_enddate DATE;
    v_duration NUMBER;
BEGIN

    proj_cursor := GetResearchProjects;


    LOOP
        FETCH proj_cursor INTO v_title, v_startdate, v_enddate, v_duration;
        EXIT WHEN proj_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Title: ' || v_title);
        DBMS_OUTPUT.PUT_LINE('Start Date: ' || v_startdate);
        DBMS_OUTPUT.PUT_LINE('End Date: ' || v_enddate);
        DBMS_OUTPUT.PUT_LINE('Duration (days): ' || v_duration);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;

    CLOSE proj_cursor;
END;



create or replace FUNCTION CheckPrerequisiteFunction(
    p_courses CourseArrayType,
    p_student REF StudentType
) RETURN CHAR
IS
    v_prerequisite REF CourseType;
    v_passed_exams NUMBER;
BEGIN

    IF p_courses.COUNT = 0 THEN
        RETURN 't'; 
    END IF;

    FOR i IN 1..p_courses.COUNT LOOP
        v_prerequisite := p_courses(i);

        SELECT COUNT(*)
        INTO v_passed_exams
        FROM Enrollment en
        WHERE DEREF(en.Student).matriculation = DEREF(p_student).matriculation
        AND DEREF(en.Course).CourseCode = DEREF(v_prerequisite).CourseCode
        AND en.ExamPassed = 't';

        IF v_passed_exams = 0 THEN
            RETURN 'f';
        END IF;
    END LOOP;

    RETURN 't';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'f';
END;




create or replace FUNCTION CreditsObtained (Matr CHAR) RETURN NUMBER IS
    total_credits NUMBER := 0;
BEGIN
    SELECT SUM(c.Credits)
    INTO total_credits
    FROM Enrollment e
    JOIN Course c ON e.Course = REF(c)  
    JOIN Student s ON e.Student = REF(s)  
    WHERE s.Matriculation = Matr  
    AND e.ExamPassed = 't';  

    RETURN NVL(total_credits, 0);  
END;




create or replace FUNCTION GetDepartmentByEmailAndPassword(
    p_staffEmail VARCHAR2,
    p_staffPassword VARCHAR2
) RETURN VARCHAR2 IS
    v_departmentName VARCHAR2(30);
BEGIN
    SELECT DEREF(s.department).DeptName
    INTO v_departmentName
    FROM Staff s  
    WHERE s.staffEmail = p_staffEmail
      AND s.staffPassword = p_staffPassword;

    DBMS_OUTPUT.PUT_LINE('Department found: ' || v_departmentName);  -- Debug output
    RETURN v_departmentName;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error retrieving department name');
END GetDepartmentByEmailAndPassword;




create or replace FUNCTION MembersPerDepartment (Dept VARCHAR) RETURN NUMBER IS
    total_members NUMBER := 0;
BEGIN
    
    SELECT COUNT(*) INTO total_members
    FROM Member m
    WHERE m.Department.DeptName = Dept;

    RETURN total_members;
END;




create or replace FUNCTION StudentsPerCourse (code CHAR) RETURN NUMBER IS
	total_students NUMBER := 0;
BEGIN	
	SELECT COUNT(*) INTO total_students
	FROM Enrollment e
	WHERE e.course.courseCode = code;

	RETURN total_students;
END;
