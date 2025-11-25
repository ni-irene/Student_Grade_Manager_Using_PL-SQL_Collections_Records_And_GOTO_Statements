SET SERVEROUTPUT ON;

DECLARE
    -- Define what one student record looks like
    TYPE student_record IS RECORD (
        student_id students.student_id%TYPE,
        student_name students.student_name%TYPE,
        test_score students.test_score%TYPE,
        letter_grade VARCHAR2(2)
    );
    
    -- Define a list to hold all students
    TYPE student_collection IS TABLE OF student_record;
    
    -- Create my list of students
    student_list student_collection;
    
    -- Temporary variable for grade calculation
    v_grade VARCHAR2(2);

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== STUDENT GRADE REPORT ===');
    DBMS_OUTPUT.PUT_LINE('');

    -- Load all students from the table into my list
    SELECT student_id, student_name, test_score, NULL
    BULK COLLECT INTO student_list
    FROM students
    ORDER BY student_id;

    -- Process each student one by one
    FOR i IN 1..student_list.COUNT LOOP
        -- Show student name and score
        DBMS_OUTPUT.PUT('Student: ' || student_list(i).student_name);
        DBMS_OUTPUT.PUT(' | Score: ' || student_list(i).test_score);
        
        -- Calculate the letter grade
        CASE 
            WHEN student_list(i).test_score >= 90 THEN v_grade := 'A';
            WHEN student_list(i).test_score >= 80 THEN v_grade := 'B';
            WHEN student_list(i).test_score >= 70 THEN v_grade := 'C';
            WHEN student_list(i).test_score >= 60 THEN v_grade := 'D';
            ELSE v_grade := 'F';
        END CASE;
        
        -- Store the grade in the student record
        student_list(i).letter_grade := v_grade;
        
        DBMS_OUTPUT.PUT(' | Grade: ' || v_grade);
        
        -- Check for perfect score (100%)
        IF student_list(i).test_score = 100 THEN
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.PUT('  >>> ');
            -- Jump to the perfect score message
            GOTO perfect_score_message;
        END IF;
        
        -- If not perfect score, skip to next student
        GOTO next_student;
        
        -- This part only runs for perfect scores
        <<perfect_score_message>>
        DBMS_OUTPUT.PUT('PERFECT SCORE! Excellent work!');
        
        -- Continue to next student
        <<next_student>>
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('---');
        
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('=== GRADE REPORT COMPLETE ===');

END;
/
