class Student
  attr_accessor :id, :name, :grade

  def set_attributes(id, name, grade)
    @id, @name, @grade = id, name, grade
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new()
    new_student.set_attributes(row[0], row[1], row[2])
    new_student
  end

  #limit refers to the amount of records to return, set it to 0 for all
  def self.get_students(condition = "", limit = 0, *values)
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT id, name, grade FROM students"
    sql += " WHERE #{condition}" unless condition == ""
    sql += " LIMIT #{limit}" unless limit == 0
    rows = DB[:conn].execute(sql, values)
    rows.collect do |row|
      new_from_db(row)
    end
  end
  def self.all
    get_students
  end

  def self.count_all_students_in_grade_9
    get_students("grade=?", 0, 9)
  end

  def self.students_below_12th_grade
    get_students("grade<?", 0, 12)
  end

  def self.first_x_students_in_grade_10(x)
    get_students("grade=?", x, 10)
  end

  def self.first_student_in_grade_10
    get_students("grade=?", 1, 10)[0]
  end

  def self.all_students_in_grade_x(x)
    get_students("grade=?", 0, x)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    students = get_students("name=?", 0, name)
    
    #we'll return the first one to pass the test
    #but this is not necessarilly correct as more than one student can have the same name
    students[0]
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
