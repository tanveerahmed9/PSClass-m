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

## Inventory Module UML Diagram

```mermaid
classDiagram
    class Item {
        +string Name
        +int Quantity
        +double Price
        +string Id
        +void UpdateQuantity(int)
        +double GetTotalValue()
        +string ToString()
    }
    class Inventory {
        +ArrayList Items
        +string InventoryName
        +void AddItem(Item)
        +void RemoveItem(string)
        +double GetTotalInventoryValue()
        +string ToString()
    }
    Inventory "1" o-- "*" Item
```
