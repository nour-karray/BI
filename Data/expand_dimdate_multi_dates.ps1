param(
    [string]$PackagePath = (Join-Path $PSScriptRoot 'Dimensions.dtsx')
)

$ErrorActionPreference = 'Stop'

$DtsNamespace = 'www.microsoft.com/SqlServer/Dts'
$ConversionComponentName = 'Conversion de donn' + [char]0x00E9 + 'es'
$ConversionInputName = 'Entr' + [char]0x00E9 + 'e de conversion de donn' + [char]0x00E9 + 'es'
$ConversionOutputName = 'Sortie de conversion de donn' + [char]0x00E9 + 'es'
$SourceOutputName = 'Sortie de source de fichier plat'
$DestinationInputName = 'Entr' + [char]0x00E9 + 'e de destination OLE DB'
$SortComponentName = 'Trier'
$SortInputName = 'Entr' + [char]0x00E9 + 'e de tri'
$SortOutputName = 'Sortie de tri'
$UnionAllName = 'Union All'
$UnionOutputName = 'Union All Output'

function Set-Attr {
    param(
        [System.Xml.XmlElement]$Element,
        [string]$Name,
        [string]$Value
    )

    [void]$Element.SetAttribute($Name, $Value)
}

function Remove-Attr {
    param(
        [System.Xml.XmlElement]$Element,
        [string]$Name
    )

    if ($Element.HasAttribute($Name)) {
        $Element.RemoveAttribute($Name)
    }
}

function Clear-Children {
    param([System.Xml.XmlNode]$Node)

    while ($Node.HasChildNodes) {
        [void]$Node.RemoveChild($Node.FirstChild)
    }
}

function Replace-InNode {
    param(
        [System.Xml.XmlNode]$Node,
        [string]$OldValue,
        [string]$NewValue
    )

    if ($Node.NodeType -in [System.Xml.XmlNodeType]::Text, [System.Xml.XmlNodeType]::CDATA) {
        if ($Node.Value -and $Node.Value.Contains($OldValue)) {
            $Node.Value = $Node.Value.Replace($OldValue, $NewValue)
        }
    }

    if ($Node.Attributes) {
        foreach ($attribute in @($Node.Attributes)) {
            if ($attribute.Value -and $attribute.Value.Contains($OldValue)) {
                $attribute.Value = $attribute.Value.Replace($OldValue, $NewValue)
            }
        }
    }

    foreach ($child in @($Node.ChildNodes)) {
        Replace-InNode -Node $child -OldValue $OldValue -NewValue $NewValue
    }
}

function Set-DbDateDataAttributes {
    param([System.Xml.XmlElement]$Element)

    Set-Attr -Element $Element -Name 'dataType' -Value 'dbDate'
    Remove-Attr -Element $Element -Name 'length'
    Remove-Attr -Element $Element -Name 'codePage'
    Remove-Attr -Element $Element -Name 'precision'
    Remove-Attr -Element $Element -Name 'scale'
}

function Set-DbDateCachedAttributes {
    param([System.Xml.XmlElement]$Element)

    Set-Attr -Element $Element -Name 'cachedDataType' -Value 'dbDate'
    Remove-Attr -Element $Element -Name 'cachedLength'
    Remove-Attr -Element $Element -Name 'cachedCodepage'
    Remove-Attr -Element $Element -Name 'cachedPrecision'
    Remove-Attr -Element $Element -Name 'cachedScale'
}

function New-PathElement {
    param(
        [System.Xml.XmlDocument]$Document,
        [string]$RefId,
        [string]$Name,
        [string]$StartId,
        [string]$EndId
    )

    $path = $Document.CreateElement('path')
    Set-Attr -Element $path -Name 'refId' -Value $RefId
    Set-Attr -Element $path -Name 'name' -Value $Name
    Set-Attr -Element $path -Name 'startId' -Value $StartId
    Set-Attr -Element $path -Name 'endId' -Value $EndId
    return $path
}

function Configure-SourceComponent {
    param(
        [System.Xml.XmlElement]$Component,
        [string]$ComponentName,
        [string]$SourceColumn
    )

    Set-Attr -Element $Component -Name 'refId' -Value "Package\DimDate\$ComponentName"
    Set-Attr -Element $Component -Name 'name' -Value $ComponentName

    $outputNode = $Component.SelectSingleNode('outputs/output[1]')
    Set-Attr -Element $outputNode -Name 'refId' -Value "Package\DimDate\$ComponentName.Outputs[$SourceOutputName]"
    Set-Attr -Element $outputNode -Name 'name' -Value $SourceOutputName

    $outputColumnsParent = $outputNode.SelectSingleNode('outputColumns')
    $templateOutputColumn = $outputColumnsParent.SelectSingleNode('outputColumn').CloneNode($true)
    Clear-Children -Node $outputColumnsParent

    $newColumn = [System.Xml.XmlElement]$templateOutputColumn.CloneNode($true)
    $baseRef = "Package\DimDate\$ComponentName.Outputs[$SourceOutputName]"
    Set-Attr -Element $newColumn -Name 'refId' -Value "$baseRef.Columns[$SourceColumn]"
    Set-Attr -Element $newColumn -Name 'externalMetadataColumnId' -Value "$baseRef.ExternalColumns[$SourceColumn]"
    Set-Attr -Element $newColumn -Name 'lineageId' -Value "$baseRef.Columns[$SourceColumn]"
    Set-Attr -Element $newColumn -Name 'name' -Value $SourceColumn
    Set-Attr -Element $newColumn -Name 'dataType' -Value 'str'
    Set-Attr -Element $newColumn -Name 'length' -Value '50'
    Set-Attr -Element $newColumn -Name 'codePage' -Value '1252'
    [void]$outputColumnsParent.AppendChild($newColumn)
}

function Configure-ConversionComponent {
    param(
        [System.Xml.XmlElement]$Component,
        [string]$ComponentName,
        [string]$SourceComponentName,
        [string]$SourceColumn
    )

    Set-Attr -Element $Component -Name 'refId' -Value "Package\DimDate\$ComponentName"
    Set-Attr -Element $Component -Name 'name' -Value $ComponentName

    $inputNode = $Component.SelectSingleNode('inputs/input[1]')
    Set-Attr -Element $inputNode -Name 'refId' -Value "Package\DimDate\$ComponentName.Inputs[$ConversionInputName]"
    Set-Attr -Element $inputNode -Name 'name' -Value $ConversionInputName

    $inputColumnsParent = $inputNode.SelectSingleNode('inputColumns')
    $templateInputColumn = $inputColumnsParent.SelectSingleNode('inputColumn').CloneNode($true)
    Clear-Children -Node $inputColumnsParent

    $sourceLineage = "Package\DimDate\$SourceComponentName.Outputs[$SourceOutputName].Columns[$SourceColumn]"
    $newInput = [System.Xml.XmlElement]$templateInputColumn.CloneNode($true)
    Set-Attr -Element $newInput -Name 'refId' -Value "Package\DimDate\$ComponentName.Inputs[$ConversionInputName].Columns[$SourceColumn]"
    Set-Attr -Element $newInput -Name 'cachedName' -Value $SourceColumn
    Set-Attr -Element $newInput -Name 'lineageId' -Value $sourceLineage
    Set-Attr -Element $newInput -Name 'cachedDataType' -Value 'str'
    Set-Attr -Element $newInput -Name 'cachedLength' -Value '50'
    Set-Attr -Element $newInput -Name 'cachedCodepage' -Value '1252'
    [void]$inputColumnsParent.AppendChild($newInput)

    $outputNode = $Component.SelectSingleNode('outputs/output[1]')
    Set-Attr -Element $outputNode -Name 'refId' -Value "Package\DimDate\$ComponentName.Outputs[$ConversionOutputName]"
    Set-Attr -Element $outputNode -Name 'name' -Value $ConversionOutputName
    Set-Attr -Element $outputNode -Name 'synchronousInputId' -Value "Package\DimDate\$ComponentName.Inputs[$ConversionInputName]"

    $outputColumnsParent = $outputNode.SelectSingleNode('outputColumns')
    $templateOutputColumn = $outputColumnsParent.SelectSingleNode('outputColumn').CloneNode($true)
    Clear-Children -Node $outputColumnsParent

    $newOutput = [System.Xml.XmlElement]$templateOutputColumn.CloneNode($true)
    $outputLineage = "Package\DimDate\$ComponentName.Outputs[$ConversionOutputName].Columns[FullDate]"
    Set-Attr -Element $newOutput -Name 'refId' -Value $outputLineage
    Set-Attr -Element $newOutput -Name 'lineageId' -Value $outputLineage
    Set-Attr -Element $newOutput -Name 'name' -Value 'FullDate'
    Set-DbDateDataAttributes -Element $newOutput
    Set-Attr -Element $newOutput -Name 'errorRowDisposition' -Value 'RedirectRow'
    Set-Attr -Element $newOutput -Name 'truncationRowDisposition' -Value 'RedirectRow'
    $sourceProperty = $newOutput.SelectSingleNode("properties/property[@name='SourceInputColumnLineageID']")
    $sourceProperty.InnerText = "#{$sourceLineage}"
    [void]$outputColumnsParent.AppendChild($newOutput)
}

function Configure-SortComponent {
    param([System.Xml.XmlElement]$Component)

    Set-Attr -Element $Component -Name 'refId' -Value "Package\DimDate\$SortComponentName"
    Set-Attr -Element $Component -Name 'name' -Value $SortComponentName
    $Component.SelectSingleNode("properties/property[@name='EliminateDuplicates']").InnerText = 'true'

    $inputNode = $Component.SelectSingleNode('inputs/input[1]')
    Set-Attr -Element $inputNode -Name 'refId' -Value "Package\DimDate\$SortComponentName.Inputs[$SortInputName]"
    Set-Attr -Element $inputNode -Name 'name' -Value $SortInputName

    $outputNode = $Component.SelectSingleNode('outputs/output[1]')
    Set-Attr -Element $outputNode -Name 'refId' -Value "Package\DimDate\$SortComponentName.Outputs[$SortOutputName]"
    Set-Attr -Element $outputNode -Name 'name' -Value $SortOutputName
    Set-Attr -Element $outputNode -Name 'isSorted' -Value 'true'

    $inputColumnsParent = $inputNode.SelectSingleNode('inputColumns')
    $templateInputColumn = $inputColumnsParent.SelectSingleNode('inputColumn').CloneNode($true)
    Clear-Children -Node $inputColumnsParent

    $unionLineage = "Package\DimDate\$UnionAllName.Outputs[$UnionOutputName].Columns[FullDate]"
    $inputColumn = [System.Xml.XmlElement]$templateInputColumn.CloneNode($true)
    Set-Attr -Element $inputColumn -Name 'refId' -Value "Package\DimDate\$SortComponentName.Inputs[$SortInputName].Columns[FullDate]"
    Set-Attr -Element $inputColumn -Name 'cachedName' -Value 'FullDate'
    Set-Attr -Element $inputColumn -Name 'lineageId' -Value $unionLineage
    Set-DbDateCachedAttributes -Element $inputColumn
    $inputColumn.SelectSingleNode("properties/property[@name='NewComparisonFlags']").InnerText = '0'
    $inputColumn.SelectSingleNode("properties/property[@name='NewSortKeyPosition']").InnerText = '1'
    [void]$inputColumnsParent.AppendChild($inputColumn)

    $outputColumnsParent = $outputNode.SelectSingleNode('outputColumns')
    $templateOutputColumn = $outputColumnsParent.SelectSingleNode('outputColumn').CloneNode($true)
    Clear-Children -Node $outputColumnsParent

    $outputColumn = [System.Xml.XmlElement]$templateOutputColumn.CloneNode($true)
    $sortLineage = "Package\DimDate\$SortComponentName.Outputs[$SortOutputName].Columns[FullDate]"
    Set-Attr -Element $outputColumn -Name 'refId' -Value $sortLineage
    Set-Attr -Element $outputColumn -Name 'lineageId' -Value $sortLineage
    Set-Attr -Element $outputColumn -Name 'name' -Value 'FullDate'
    Set-DbDateDataAttributes -Element $outputColumn
    Set-Attr -Element $outputColumn -Name 'sortKeyPosition' -Value '1'
    $outputColumn.SelectSingleNode("properties/property[@name='SortColumnId']").InnerText = "#{$unionLineage}"
    [void]$outputColumnsParent.AppendChild($outputColumn)
}

function Configure-DestinationComponent {
    param([System.Xml.XmlElement]$Component)

    Set-Attr -Element $Component -Name 'refId' -Value 'Package\DimDate\Destination OLE DB'
    Set-Attr -Element $Component -Name 'name' -Value 'Destination OLE DB'
    $Component.SelectSingleNode("properties/property[@name='OpenRowset']").InnerText = '[dbo].[DimDate]'

    $inputNode = $Component.SelectSingleNode('inputs/input[1]')
    Set-Attr -Element $inputNode -Name 'refId' -Value "Package\DimDate\Destination OLE DB.Inputs[$DestinationInputName]"
    Set-Attr -Element $inputNode -Name 'name' -Value $DestinationInputName

    $inputColumnsParent = $inputNode.SelectSingleNode('inputColumns')
    $externalMetadataParent = $inputNode.SelectSingleNode('externalMetadataColumns')
    $templateInputColumn = $inputColumnsParent.SelectSingleNode('inputColumn').CloneNode($true)
    $templateExternal = $externalMetadataParent.SelectSingleNode('externalMetadataColumn').CloneNode($true)

    Clear-Children -Node $inputColumnsParent
    Clear-Children -Node $externalMetadataParent

    $dateKeyColumn = [System.Xml.XmlElement]$templateExternal.CloneNode($true)
    Set-Attr -Element $dateKeyColumn -Name 'refId' -Value "Package\DimDate\Destination OLE DB.Inputs[$DestinationInputName].ExternalColumns[DateKey]"
    Set-Attr -Element $dateKeyColumn -Name 'name' -Value 'DateKey'
    Set-Attr -Element $dateKeyColumn -Name 'dataType' -Value 'i4'
    Remove-Attr -Element $dateKeyColumn -Name 'length'
    Remove-Attr -Element $dateKeyColumn -Name 'codePage'
    [void]$externalMetadataParent.AppendChild($dateKeyColumn)

    $fullDateInput = [System.Xml.XmlElement]$templateInputColumn.CloneNode($true)
    $sortLineage = "Package\DimDate\$SortComponentName.Outputs[$SortOutputName].Columns[FullDate]"
    Set-Attr -Element $fullDateInput -Name 'refId' -Value "Package\DimDate\Destination OLE DB.Inputs[$DestinationInputName].Columns[FullDate]"
    Set-Attr -Element $fullDateInput -Name 'cachedName' -Value 'FullDate'
    Set-Attr -Element $fullDateInput -Name 'externalMetadataColumnId' -Value "Package\DimDate\Destination OLE DB.Inputs[$DestinationInputName].ExternalColumns[FullDate]"
    Set-Attr -Element $fullDateInput -Name 'lineageId' -Value $sortLineage
    Set-DbDateCachedAttributes -Element $fullDateInput
    [void]$inputColumnsParent.AppendChild($fullDateInput)

    $fullDateExternal = [System.Xml.XmlElement]$templateExternal.CloneNode($true)
    Set-Attr -Element $fullDateExternal -Name 'refId' -Value "Package\DimDate\Destination OLE DB.Inputs[$DestinationInputName].ExternalColumns[FullDate]"
    Set-Attr -Element $fullDateExternal -Name 'name' -Value 'FullDate'
    Set-DbDateDataAttributes -Element $fullDateExternal
    [void]$externalMetadataParent.AppendChild($fullDateExternal)
}

function New-UnionAllComponent {
    param(
        [System.Xml.XmlDocument]$Document,
        [hashtable[]]$Branches
    )

    $component = $Document.CreateElement('component')
    Set-Attr -Element $component -Name 'refId' -Value "Package\DimDate\$UnionAllName"
    Set-Attr -Element $component -Name 'componentClassID' -Value 'Microsoft.UnionAll'
    Set-Attr -Element $component -Name 'contactInfo' -Value 'Union All;Microsoft Corporation; Microsoft SQL Server; (C) Microsoft Corporation; Tous droits reserves; http://www.microsoft.com/sql/support;1'
    Set-Attr -Element $component -Name 'description' -Value 'Combine plusieurs entrees en une seule sortie.'
    Set-Attr -Element $component -Name 'name' -Value $UnionAllName
    Set-Attr -Element $component -Name 'version' -Value '1'

    $inputs = $Document.CreateElement('inputs')
    [void]$component.AppendChild($inputs)

    $outputLineage = "Package\DimDate\$UnionAllName.Outputs[$UnionOutputName].Columns[FullDate]"

    for ($i = 0; $i -lt $Branches.Count; $i++) {
        $branch = $Branches[$i]
        $inputName = 'Union All Input ' + ($i + 1)
        $input = $Document.CreateElement('input')
        Set-Attr -Element $input -Name 'refId' -Value "Package\DimDate\$UnionAllName.Inputs[$inputName]"
        Set-Attr -Element $input -Name 'name' -Value $inputName

        $inputColumns = $Document.CreateElement('inputColumns')
        $inputColumn = $Document.CreateElement('inputColumn')
        Set-Attr -Element $inputColumn -Name 'refId' -Value "Package\DimDate\$UnionAllName.Inputs[$inputName].Columns[FullDate]"
        Set-Attr -Element $inputColumn -Name 'cachedDataType' -Value 'dbDate'
        Set-Attr -Element $inputColumn -Name 'cachedName' -Value 'FullDate'
        Set-Attr -Element $inputColumn -Name 'lineageId' -Value $branch.LineageId
        $properties = $Document.CreateElement('properties')
        $property = $Document.CreateElement('property')
        Set-Attr -Element $property -Name 'containsID' -Value 'true'
        Set-Attr -Element $property -Name 'dataType' -Value 'System.Int32'
        Set-Attr -Element $property -Name 'description' -Value "Specifie l'identificateur de tracabilite de la colonne de sortie correspondante."
        Set-Attr -Element $property -Name 'name' -Value 'OutputColumnLineageID'
        $property.InnerText = "#{$outputLineage}"
        [void]$properties.AppendChild($property)
        [void]$inputColumn.AppendChild($properties)
        [void]$inputColumns.AppendChild($inputColumn)
        [void]$input.AppendChild($inputColumns)
        [void]$input.AppendChild($Document.CreateElement('externalMetadataColumns'))
        [void]$inputs.AppendChild($input)
    }

    $outputs = $Document.CreateElement('outputs')
    $output = $Document.CreateElement('output')
    Set-Attr -Element $output -Name 'refId' -Value "Package\DimDate\$UnionAllName.Outputs[$UnionOutputName]"
    Set-Attr -Element $output -Name 'name' -Value $UnionOutputName

    $outputColumns = $Document.CreateElement('outputColumns')
    $outputColumn = $Document.CreateElement('outputColumn')
    Set-Attr -Element $outputColumn -Name 'refId' -Value $outputLineage
    Set-Attr -Element $outputColumn -Name 'dataType' -Value 'dbDate'
    Set-Attr -Element $outputColumn -Name 'lineageId' -Value $outputLineage
    Set-Attr -Element $outputColumn -Name 'name' -Value 'FullDate'
    [void]$outputColumns.AppendChild($outputColumn)
    [void]$output.AppendChild($outputColumns)
    [void]$output.AppendChild($Document.CreateElement('externalMetadataColumns'))
    [void]$outputs.AppendChild($output)
    [void]$component.AppendChild($outputs)

    return $component
}

if (-not (Test-Path -LiteralPath $PackagePath)) {
    throw "Package introuvable : $PackagePath"
}

$packageDoc = New-Object System.Xml.XmlDocument
$packageDoc.PreserveWhitespace = $true
$packageDoc.Load($PackagePath)

$namespaceManager = New-Object System.Xml.XmlNamespaceManager($packageDoc.NameTable)
$namespaceManager.AddNamespace('DTS', $DtsNamespace)

$dimDateTask = [System.Xml.XmlElement]$packageDoc.SelectSingleNode("/DTS:Executable/DTS:Executables/DTS:Executable[@DTS:ObjectName='DimDate']", $namespaceManager)
if ($null -eq $dimDateTask) {
    throw 'Tache DimDate introuvable.'
}

$pipeline = $dimDateTask.SelectSingleNode('DTS:ObjectData/pipeline', $namespaceManager)
$componentsNode = $pipeline.SelectSingleNode('components')
$pathsNode = $pipeline.SelectSingleNode('paths')

$sourceTemplate = [System.Xml.XmlElement]$dimDateTask.SelectSingleNode(".//component[@componentClassID='Microsoft.FlatFileSource']")
$conversionTemplate = [System.Xml.XmlElement]$dimDateTask.SelectSingleNode(".//component[@componentClassID='Microsoft.DataConvert']")
$destinationTemplate = [System.Xml.XmlElement]$dimDateTask.SelectSingleNode(".//component[@componentClassID='Microsoft.OLEDBDestination']")
$sortTemplate = [System.Xml.XmlElement]$packageDoc.SelectSingleNode("/DTS:Executable/DTS:Executables/DTS:Executable[@DTS:ObjectName='DimDepartment']/DTS:ObjectData/pipeline/components/component[@componentClassID='Microsoft.Sort']", $namespaceManager)

if ($null -eq $sourceTemplate -or $null -eq $conversionTemplate -or $null -eq $destinationTemplate -or $null -eq $sortTemplate) {
    throw 'Impossible de recuperer les composants de base pour reconstruire DimDate.'
}

$source1 = [System.Xml.XmlElement]$sourceTemplate.CloneNode($true)
$source2 = [System.Xml.XmlElement]$sourceTemplate.CloneNode($true)
$source3 = [System.Xml.XmlElement]$sourceTemplate.CloneNode($true)
Replace-InNode -Node $source2 -OldValue 'Package\DimDate\Source du fichier plat' -NewValue 'Package\DimDate\Source du fichier plat 1'
Replace-InNode -Node $source3 -OldValue 'Package\DimDate\Source du fichier plat' -NewValue 'Package\DimDate\Source du fichier plat 2'
Configure-SourceComponent -Component $source1 -ComponentName 'Source du fichier plat' -SourceColumn 'DateofHire'
Configure-SourceComponent -Component $source2 -ComponentName 'Source du fichier plat 1' -SourceColumn 'DateofTermination'
Configure-SourceComponent -Component $source3 -ComponentName 'Source du fichier plat 2' -SourceColumn 'LastPerformanceReview_Date'

$conversion1 = [System.Xml.XmlElement]$conversionTemplate.CloneNode($true)
$conversion2 = [System.Xml.XmlElement]$conversionTemplate.CloneNode($true)
$conversion3 = [System.Xml.XmlElement]$conversionTemplate.CloneNode($true)
Replace-InNode -Node $conversion2 -OldValue "Package\DimDate\$ConversionComponentName" -NewValue "Package\DimDate\$ConversionComponentName 1"
Replace-InNode -Node $conversion3 -OldValue "Package\DimDate\$ConversionComponentName" -NewValue "Package\DimDate\$ConversionComponentName 2"
Configure-ConversionComponent -Component $conversion1 -ComponentName $ConversionComponentName -SourceComponentName 'Source du fichier plat' -SourceColumn 'DateofHire'
Configure-ConversionComponent -Component $conversion2 -ComponentName ($ConversionComponentName + ' 1') -SourceComponentName 'Source du fichier plat 1' -SourceColumn 'DateofTermination'
Configure-ConversionComponent -Component $conversion3 -ComponentName ($ConversionComponentName + ' 2') -SourceComponentName 'Source du fichier plat 2' -SourceColumn 'LastPerformanceReview_Date'

$unionAll = New-UnionAllComponent -Document $packageDoc -Branches @(
    @{ LineageId = "Package\DimDate\$ConversionComponentName.Outputs[$ConversionOutputName].Columns[FullDate]" },
    @{ LineageId = "Package\DimDate\$ConversionComponentName 1.Outputs[$ConversionOutputName].Columns[FullDate]" },
    @{ LineageId = "Package\DimDate\$ConversionComponentName 2.Outputs[$ConversionOutputName].Columns[FullDate]" }
)

$sortComponent = [System.Xml.XmlElement]$packageDoc.ImportNode($sortTemplate, $true)
Replace-InNode -Node $sortComponent -OldValue 'Package\DimDepartment\Trier' -NewValue 'Package\DimDate\Trier'
Configure-SortComponent -Component $sortComponent

$destination = [System.Xml.XmlElement]$destinationTemplate.CloneNode($true)
Configure-DestinationComponent -Component $destination

Clear-Children -Node $componentsNode
[void]$componentsNode.AppendChild($source1)
[void]$componentsNode.AppendChild($source2)
[void]$componentsNode.AppendChild($source3)
[void]$componentsNode.AppendChild($conversion1)
[void]$componentsNode.AppendChild($conversion2)
[void]$componentsNode.AppendChild($conversion3)
[void]$componentsNode.AppendChild($unionAll)
[void]$componentsNode.AppendChild($sortComponent)
[void]$componentsNode.AppendChild($destination)

Clear-Children -Node $pathsNode
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de source de fichier plat]' -Name 'Sortie de source de fichier plat' -StartId 'Package\DimDate\Source du fichier plat.Outputs[Sortie de source de fichier plat]' -EndId "Package\DimDate\$ConversionComponentName.Inputs[$ConversionInputName]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de source de fichier plat 1]' -Name 'Sortie de source de fichier plat 1' -StartId 'Package\DimDate\Source du fichier plat 1.Outputs[Sortie de source de fichier plat]' -EndId "Package\DimDate\$ConversionComponentName 1.Inputs[$ConversionInputName]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de source de fichier plat 2]' -Name 'Sortie de source de fichier plat 2' -StartId 'Package\DimDate\Source du fichier plat 2.Outputs[Sortie de source de fichier plat]' -EndId "Package\DimDate\$ConversionComponentName 2.Inputs[$ConversionInputName]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de conversion de données]' -Name 'Sortie de conversion de données' -StartId "Package\DimDate\$ConversionComponentName.Outputs[$ConversionOutputName]" -EndId "Package\DimDate\$UnionAllName.Inputs[Union All Input 1]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de conversion de données 1]' -Name 'Sortie de conversion de données 1' -StartId "Package\DimDate\$ConversionComponentName 1.Outputs[$ConversionOutputName]" -EndId "Package\DimDate\$UnionAllName.Inputs[Union All Input 2]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de conversion de données 2]' -Name 'Sortie de conversion de données 2' -StartId "Package\DimDate\$ConversionComponentName 2.Outputs[$ConversionOutputName]" -EndId "Package\DimDate\$UnionAllName.Inputs[Union All Input 3]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Union All Output]' -Name 'Union All Output' -StartId "Package\DimDate\$UnionAllName.Outputs[$UnionOutputName]" -EndId "Package\DimDate\$SortComponentName.Inputs[$SortInputName]"))
[void]$pathsNode.AppendChild((New-PathElement -Document $packageDoc -RefId 'Package\DimDate.Paths[Sortie de tri]' -Name 'Sortie de tri' -StartId "Package\DimDate\$SortComponentName.Outputs[$SortOutputName]" -EndId "Package\DimDate\Destination OLE DB.Inputs[$DestinationInputName]"))

$packageDoc.Save($PackagePath)

[pscustomobject]@{
    PackagePath = $PackagePath
    DimDateMode = 'Three source dates merged into FullDate'
} | Format-List
