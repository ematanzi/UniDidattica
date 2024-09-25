-- index and sequence

CREATE INDEX idx_assignment_date ON
Assignment(AssignmentDate);

CREATE INDEX idx_course_title ON
Course(CourseTitle);

CREATE INDEX idx_enroll_date ON
Enrollment(EnrollmentDate);

CREATE INDEX idx_exam_date ON 
Exam(ExamDate);

CREATE INDEX idx_member_compname ON 
Member(FirstName, LastName);

CREATE INDEX idx_research_time ON
ResearchProject(StartDate, EndDate);

CREATE INDEX idx_student_compname ON
Student(FirstName, LastName);

CREATE INDEX idx_tuition_exp ON
Tuition(Expiration);

CREATE SEQUENCE  RANDOMAMOUNT  MINVALUE 50 MAXVALUE 1000 INCREMENT BY 2 START WITH 422 CACHE 20 NOORDER  CYCLE  NOKEEP  NOSCALE  GLOBAL ;