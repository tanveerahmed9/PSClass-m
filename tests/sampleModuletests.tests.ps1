# InventoryModule.Tests.ps1
# Pester tests for InventoryModule.psm1

# Import the module to test
Import-Module -Name ./InventoryModule.psm1 -Force

Describe "Item Class Tests" {
    Context "Item Creation" {
        It "Should create an Item with correct properties" {
            $item = New-InventoryItem -Name "TestItem" -Quantity 10 -Price 5.99
            $item.Name | Should -Be "TestItem"
            $item.Quantity | Should -Be 10
            $item.Price | Should -Be 5.99
            $item.Id | Should -Not -BeNullOrEmpty
            $item.Id | Should -Match "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
        }
    }

    Context "Item Methods" {
        BeforeEach {
            $item = New-InventoryItem -Name "TestItem" -Quantity 10 -Price 5.99
        }

        It "Should update quantity correctly" {
            $item.UpdateQuantity(20)
            $item.Quantity | Should -Be 20
        }

        It "Should throw error for negative quantity" {
            { $item.UpdateQuantity(-5) } | Should -Throw "*Quantity cannot be negative*"
        }

        It "Should calculate total value correctly" {
            $item.GetTotalValue() | Should -Be (10 * 5.99)
        }

        It "Should return correct string representation" {
            $item.ToString() | Should -Match "Item: TestItem, ID: .*, Quantity: 10, Price: 5.99, Total Value: 59.9"
        }
    }
}

Describe "Inventory Class Tests" {
    Context "Inventory Creation" {
        It "Should create an Inventory with correct properties" {
            $inventory = New-Inventory -Name "TestInventory"
            $inventory.InventoryName | Should -Be "TestInventory"
            $inventory.Items | Should -BeOfType [System.Collections.ArrayList]
            $inventory.Items.Count | Should -Be 0
        }
    }

    Context "Inventory Methods" {
        BeforeEach {
            $inventory = New-Inventory -Name "TestInventory"
            $item1 = New-InventoryItem -Name "Item1" -Quantity 10 -Price 5.99
            $item2 = New-InventoryItem -Name "Item2" -Quantity 5 -Price 10.00
            $inventory.AddItem($item1)
            $inventory.AddItem($item2)
        }

        It "Should add items correctly" {
            $inventory.Items.Count | Should -Be 2
            $inventory.Items[0].Name | Should -Be "Item1"
            $inventory.Items[1].Name | Should -Be "Item2"
        }

        It "Should remove item by ID" {
            $itemId = $inventory.Items[0].Id
            $inventory.RemoveItem($itemId)
            $inventory.Items.Count | Should -Be 1
            $inventory.Items[0].Name | Should -Be "Item2"
        }

        It "Should throw error when removing non-existent item" {
            { $inventory.RemoveItem("non-existent-id") } | Should -Throw "*Item with ID non-existent-id not found*"
        }

        It "Should calculate total inventory value correctly" {
            $expectedValue = (10 * 5.99) + (5 * 10.00)
            $inventory.GetTotalInventoryValue() | Should -Be $expectedValue
        }

        It "Should return correct string representation" {
            $result = $inventory.ToString()
            $result | Should -Match "Inventory: TestInventory"
            $result | Should -Match "Total Items: 2"
            $result | Should -Match "Item: Item1"
            $result | Should -Match "Item: Item2"
        }
    }
}