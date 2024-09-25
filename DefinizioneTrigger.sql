-- triggers definition

create or replace TRIGGER CheckAttendingValues
BEFORE INSERT OR UPDATE ON Course
FOR EACH ROW
DECLARE
    sem CHAR(1) := :new.AttendingInfo.Semester;
    yea CHAR(1) := :new.AttendingInfo.AttendingYear;
BEGIN
    IF sem <> '1' AND sem <> '2' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Specified semester value not valid.');
    END IF;

    IF yea <> '1' AND yea <> '2' AND yea <> '3' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Specified year not valid.');
    END IF;
END;




create or replace TRIGGER CheckCourseDepartment
BEFORE INSERT OR UPDATE ON Course
FOR EACH ROW
DECLARE
    TeacherDept VARCHAR2(30);
    ProgramDept VARCHAR2(30);
    v_program DegreeProgramType;
    v_member MemberType;

BEGIN
    SELECT DEREF(:new.degreeProgram) INTO v_program FROM DUAL; 
    SELECT DEREF(:new.teacher) INTO v_member FROM DUAL;

    SELECT DEREF(department).deptName INTO ProgramDept FROM DegreeProgram
    WHERE v_program.degreeName = degreeName;

    SELECT DEREF(department).deptName INTO TeacherDept FROM Member
    WHERE v_member.matriculation = matriculation;

    IF ProgramDept != TeacherDept THEN
        RAISE_APPLICATION_ERROR(-20001, 'Operation not allowed: teacher and course must be of the same Department');
    END IF;

END;




create or replace TRIGGER CheckCreditCoherence
BEFORE INSERT OR UPDATE OF Credits ON Course
FOR EACH ROW

BEGIN
    IF :new.Credits > 12 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Credits superior to the upper bound 12');
    END IF;
END;




create or replace TRIGGER CheckDateCoherence
BEFORE INSERT OR UPDATE ON ResearchProject
FOR EACH ROW

BEGIN
    IF :new.EndDate < :new.startDate THEN
        RAISE_APPLICATION_ERROR(-20001, 'Date inconsistency: the end date cannot be before the start date');
    END IF;
END;




create or replace TRIGGER CheckExamDateCoherence
BEFORE INSERT OR UPDATE OF ExamDate ON Exam
FOR EACH ROW
DECLARE
    v_enroll EnrollmentType; 
BEGIN
    SELECT DEREF(:new.enroll) INTO v_enroll FROM DUAL;

    IF v_enroll.EnrollmentDate > :new.examdate THEN
        RAISE_APPLICATION_ERROR(-20001, 'The date of the exam is not valid');
    END IF;
END;




create or replace TRIGGER CheckExamMarkCoherence
BEFORE INSERT OR UPDATE OF Mark ON Exam
FOR EACH ROW

BEGIN
    IF :new.Mark < 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Mark inferior to the lower bound 1');
    END IF;
    IF :new.Mark > 31 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Mark superior to the upper bound 1');
    END IF;
END;




create or replace TRIGGER CheckExamPassedCoherence
AFTER INSERT OR UPDATE OF ExamPassed ON Enrollment
FOR EACH ROW

BEGIN
    IF :new.ExamPassed <> 't' and :new.ExamPassed <> 'f' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in flag insertion');
    END IF;
END;




create or replace TRIGGER CheckIfSameDepartment
BEFORE INSERT OR UPDATE ON Enrollment
FOR EACH ROW
DECLARE
    StudentDept VARCHAR(30);
    DegreeProgramName VARCHAR(30);
    DegreeProgramDept VARCHAR(30);
    v_student StudentType;
    v_course CourseType;
BEGIN
    SELECT DEREF(:new.student) INTO v_student FROM DUAL;
    SELECT DEREF(:new.course) INTO v_course FROM DUAL;

    SELECT Deref(department).DeptName INTO StudentDept FROM Student
    WHERE v_student.matriculation = matriculation;

    SELECT DEREF(DegreeProgram).DegreeName INTO DegreeProgramName FROM Course
    WHERE v_course.coursecode = coursecode;

    SELECT DEREF(Department).deptName INTO DegreeProgramDept FROM DegreeProgram
    WHERE DEREF(v_course.DegreeProgram).DegreeName = DegreeName;

    IF StudentDept <> DegreeProgramDept THEN
        RAISE_APPLICATION_ERROR(-20001, 'Operation not allowed: student and course must be of the same Department');
    END IF;
END;




create or replace TRIGGER CheckPrerequisites
BEFORE INSERT ON Enrollment
FOR EACH ROW
DECLARE
    CourseArray CourseArrayType;
    IsValid CHAR(1);

BEGIN
    SELECT Prerequisites INTO CourseArray FROM Course
    WHERE CourseCode = DEREF(:new.course).CourseCode;

    IsValid := CheckPrerequisiteFunction(CourseArray, :new.student);

    IF IsValid = 'f' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Operation not allowed: not all pre-requisites are satisfied');
    END IF;

END;




create or replace TRIGGER checkprerequisitesDegreeProgram
BEFORE INSERT ON Course
FOR EACH ROW
DECLARE
    v_prerequisite CourseType;         
    v_degree_program DegreeProgramType; 
    v_new_degree_program DegreeProgramType; 
BEGIN
    SELECT DEREF(:NEW.DegreeProgram) INTO v_new_degree_program FROM DUAL;

    IF :NEW.Prerequisites IS NOT NULL THEN
        FOR i IN 1..:NEW.Prerequisites.COUNT LOOP
            SELECT DEREF(:NEW.Prerequisites(i)) INTO v_prerequisite FROM DUAL;

            SELECT DEREF(v_prerequisite.DegreeProgram) INTO v_degree_program FROM DUAL;

            IF v_degree_program.degreeName != v_new_degree_program.degreeName THEN
                RAISE_APPLICATION_ERROR(-20001, 'Il corso prerequisito ha un DegreeProgram diverso dal corso inserito.');
            END IF;
        END LOOP;
    END IF;
END;




create or replace TRIGGER CheckTuitionCoherence
AFTER INSERT OR UPDATE OF Paid ON Tuition
FOR EACH ROW

BEGIN
    IF :new.Paid <> 't' AND :new.Paid <> 'f' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in flag insertion');
    END IF;
END;




create or replace TRIGGER DeleteAssignmentAfterEnrollment
AFTER DELETE ON ENROLLMENT

BEGIN

    DELETE FROM Assignment a
    WHERE NOT EXISTS (
        SELECT 1
        FROM Enrollment e
        WHERE a.enroll = REF(e)
    );

END;




create or replace TRIGGER DeleteCourseAfterDegreeProgram
AFTER DELETE ON DEGREEPROGRAM

BEGIN

    DELETE FROM Course c
    WHERE NOT EXISTS (
        SELECT 1
        FROM DegreeProgram d
        WHERE c.degreeprogram = REF(d)
    );

END;




create or replace TRIGGER DeleteDegreeProgramAfterDepartment
AFTER DELETE ON DEPARTMENT

BEGIN

    DELETE FROM DegreeProgram dgr
    WHERE NOT EXISTS (
        SELECT 1
        FROM Department d
        WHERE dgr.department = REF(d)
    );

END;




create or replace TRIGGER DeleteEnrollmentAfterStudent
AFTER DELETE ON Student

BEGIN

    DELETE FROM Enrollment en
    WHERE NOT EXISTS (
        SELECT 1
        FROM STUDENT s
        WHERE en.student = REF(s)
    );

END;




create or replace TRIGGER DeleteExamAfterEnrollment
AFTER DELETE ON ENROLLMENT

BEGIN

    DELETE FROM Exam ex
    WHERE NOT EXISTS (
        SELECT 1
        FROM Enrollment e
        WHERE ex.enroll = REF(e)
    );

END;




create or replace TRIGGER DeleteMemberAfterDepartment
AFTER DELETE ON DEPARTMENT

BEGIN

    DELETE FROM Member m
    WHERE NOT EXISTS (
        SELECT 1
        FROM Department d
        WHERE m.department = REF(d)
    );

END;




create or replace TRIGGER DeleteStudentAfterDepartment
AFTER DELETE ON DEPARTMENT

BEGIN

    DELETE FROM Student s
    WHERE NOT EXISTS (
        SELECT 1
        FROM Department d
        WHERE s.department = REF(d)
    );

END;




create or replace TRIGGER DeleteTuitionAfterDegreeProgram
AFTER DELETE ON DegreeProgram

BEGIN

    DELETE FROM Tuition t
    WHERE NOT EXISTS (
        SELECT 1
        FROM DegreeProgram d
        WHERE t.degreeprogram = REF(d)
    );

END;




create or replace TRIGGER DeleteTuitionAfterStudent
AFTER DELETE ON Student

BEGIN

    DELETE FROM Tuition t
    WHERE NOT EXISTS (
        SELECT 1
        FROM Student s
        WHERE t.student = REF(s)
    );

END;




create or replace TRIGGER IsNowTeaching
AFTER INSERT ON Course
FOR EACH ROW
DECLARE
    IsTeaching CHAR;
    v_teacher MemberType;
BEGIN

    SELECT DEREF(:new.teacher) INTO v_teacher FROM DUAL;

    SELECT m.teaches INTO IsTeaching FROM Member m
    WHERE m.matriculation = v_teacher.matriculation;

    IF IsTeaching = 'f' THEN
        UPDATE Member SET teaches = 't'
        WHERE matriculation = v_teacher.matriculation;

        dbms_output.put_line('Teacher ' || v_teacher.matriculation || ' has been updated');
    END IF;
END;



create or replace TRIGGER ModifyCourseNullPrerequisites
BEFORE INSERT OR UPDATE OF Prerequisites ON Course
FOR EACH ROW

BEGIN
    UPDATE Course
    SET Prerequisites = CourseArrayType()
    WHERE Prerequisites IS NULL;
END;




create or replace TRIGGER NotDoubleInsertionInEnrollment
BEFORE INSERT OR UPDATE ON Enrollment
FOR EACH ROW
DECLARE
    v_count NUMBER;

BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM Enrollment e
    WHERE DEREF(e.student).matriculation = DEREF(:new.student).matriculation AND
    DEREF(e.course).courseCode = DEREF(:new.course).courseCode;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Duplicate enrollment: this student is already enrolled in the same Course.');
    END IF;

END;





create or replace TRIGGER NotDoubleInsertionsInExtra
BEFORE INSERT OR UPDATE ON EnrolledInExtra
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM EnrolledInExtra ei
    WHERE DEREF(ei.ExtraActivity).ActivityCode = DEREF(:NEW.ExtraActivity).ActivityCode
    AND DEREF(ei.Student).matriculation = DEREF(:NEW.Student).matriculation;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Duplicate enrollment: this student is already enrolled in the same ExtraActivity.');
    END IF;
END;




create or replace TRIGGER StoreDeletedStudents
BEFORE DELETE ON Student
FOR EACH ROW
BEGIN
    INSERT INTO TempDeletedStudents (matriculation) 
    VALUES (:OLD.matriculation);
END;
