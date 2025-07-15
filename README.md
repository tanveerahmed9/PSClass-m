# PSClass-m
refresher for classes and modules in PowerShell

This project is for my refresher on Advance classes and Modules development in PS

Re-usabilty

lets sketch classes for the requirement

## Sample UML Diagram

```mermaid
classDiagram
    class Person {
        +string Name
        +int Age
        +void Speak()
    }
    class Student {
        +string StudentId
        +void Study()
    }
    class Teacher {
        +string EmployeeId
        +void Teach()
    }
    Person <|-- Student
    Person <|-- Teacher
```
