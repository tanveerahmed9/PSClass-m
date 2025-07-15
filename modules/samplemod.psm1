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
        Write-Verbose "Creating Item: Name=$name, Quantity=$quantity, Price=$price"
        $this.Name = $name
        $this.Quantity = $quantity
        $this.Price = $price
        $this.Id = [guid]::NewGuid().ToString()
        Write-Debug "Item created with Id: $($this.Id)"
    }

    # Method to update quantity
    [void]UpdateQuantity([int]$newQuantity) {
        Write-Verbose "Updating quantity for Item Id=$($this.Id) to $newQuantity"
        if ($newQuantity -ge 0) {
            $this.Quantity = $newQuantity
            Write-Debug "Quantity updated successfully"
        } else {
            Write-Error "Quantity cannot be negative"
        }
    }

    # Method to calculate total value
    [double]GetTotalValue() {
        Write-Verbose "Calculating total value for Item Id=$($this.Id)"
        return $this.Quantity * $this.Price
    }

    # Method to display item details
    [string]ToString() {
        Write-Debug "Generating string for Item Id=$($this.Id)"
        return "Item: $($this.Name), ID: $($this.Id), Quantity: $($this.Quantity), Price: $($this.Price), Total Value: $($this.GetTotalValue())"
    }
}

class Inventory {
    # Properties
    [System.Collections.ArrayList]$Items
    [string]$InventoryName

    # Constructor
    Inventory([string]$name) {
        Write-Verbose "Creating Inventory: Name=$name"
        $this.InventoryName = $name
        $this.Items = New-Object System.Collections.ArrayList
        Write-Debug "Inventory created"
    }

    # Method to add an item
    [void]AddItem([Item]$item) {
        Write-Verbose "Adding Item Id=$($item.Id) to Inventory=$($this.InventoryName)"
        $null = $this.Items.Add($item)
        Write-Debug "Item added. Total items: $($this.Items.Count)"
    }

    # Method to remove an item by ID
    [void]RemoveItem([string]$itemId) {
        Write-Verbose "Removing Item Id=$itemId from Inventory=$($this.InventoryName)"
        $itemToRemove = $this.Items | Where-Object { $_.Id -eq $itemId }
        if ($itemToRemove) {
            $null = $this.Items.Remove($itemToRemove)
            Write-Debug "Item removed. Total items: $($this.Items.Count)"
        } else {
            Write-Error "Item with ID $itemId not found"
        }
    }

    # Method to get total inventory value
    [double]GetTotalInventoryValue() {
        Write-Verbose "Calculating total inventory value for Inventory=$($this.InventoryName)"
        $total = 0.0
        foreach ($item in $this.Items) {
            $total += $item.GetTotalValue()
        }
        return $total
    }

    # Method to display all items
    [string]ToString() {
        Write-Debug "Generating string for Inventory=$($this.InventoryName)"
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
    Write-Verbose "Calling New-Inventory with Name=$Name"
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
    Write-Verbose "Calling New-InventoryItem with Name=$Name, Quantity=$Quantity, Price=$Price"
    return [Item]::new($Name, $Quantity, $Price)
}

# Export module members
Export-ModuleMember -Function New-Inventory, New-InventoryItem