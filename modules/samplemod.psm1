# InventoryModule.psm1
# A PowerShell module for managing inventory items

class Item {
    # Properties
    [string]$Name
    [int]$Quantity
    [double]$Price
    [string]$Id

    # Constructor
    Item([string]$name, [int]$quantity, [double]$price) {
        $this.Name = $name
        $this.Quantity = $quantity
        $this.Price = $price
        $this.Id = [guid]::NewGuid().ToString()
    }

    # Method to update quantity
    [void]UpdateQuantity([int]$newQuantity) {
        if ($newQuantity -ge 0) {
            $this.Quantity = $newQuantity
        } else {
            Write-Error "Quantity cannot be negative"
        }
    }

    # Method to calculate total value
    [double]GetTotalValue() {
        return $this.Quantity * $this.Price
    }

    # Method to display item details
    [string]ToString() {
        return "Item: $($this.Name), ID: $($this.Id), Quantity: $($this.Quantity), Price: $($this.Price), Total Value: $($this.GetTotalValue())"
    }
}

class Inventory {
    # Properties
    [System.Collections.ArrayList]$Items
    [string]$InventoryName

    # Constructor
    Inventory([string]$name) {
        $this.InventoryName = $name
        $this.Items = New-Object System.Collections.ArrayList
    }

    # Method to add an item
    [void]AddItem([Item]$item) {
        $null = $this.Items.Add($item)
    }

    # Method to remove an item by ID
    [void]RemoveItem([string]$itemId) {
        $itemToRemove = $this.Items | Where-Object { $_.Id -eq $itemId }
        if ($itemToRemove) {
            $null = $this.Items.Remove($itemToRemove)
        } else {
            Write-Error "Item with ID $itemId not found"
        }
    }

    # Method to get total inventory value
    [double]GetTotalInventoryValue() {
        $total = 0.0
        foreach ($item in $this.Items) {
            $total += $item.GetTotalValue()
        }
        return $total
    }

    # Method to display all items
    [string]ToString() {
        $output = "Inventory: $($this.InventoryName)`n"
        $output += "Total Items: $($this.Items.Count)`n"
        $output += "Total Value: $($this.GetTotalInventoryValue())`n"
        $output += "Items:`n"
        foreach ($item in $this.Items) {
            $output += "  $($item.ToString())`n"
        }
        return $output
    }
}

# Exported functions for module usability
function New-Inventory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    return [Inventory]::new($Name)
}

function New-InventoryItem {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [int]$Quantity,
        [Parameter(Mandatory=$true)]
        [double]$Price
    )
    return [Item]::new($Name, $Quantity, $Price)
}

# Export module members
Export-ModuleMember -Function New-Inventory, New-InventoryItem