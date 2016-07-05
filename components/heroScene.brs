
sub init()
  ' create the list content
  print "starting init"
  m.testListContent = createObject("RoSGNode", "ContentNode")

  ' the component for each list item is
  ' in a parallel roArray
  m.testComponents = createObject("RoArray", 3, true)
  print "testComponents "; testComponents

  addListItem("FloatingFocus - Full screen width", "FloatFullScreen")
  addListItem("FloatingFocus - Crop width to items", "FloatCropToItems")
  addListItem("FixedFocusWrap - Full screen width", "FixedFullScreen")
  addListItem("FixedFocusWrap - Crop width to items", "FixedCropToItems")

  print "TestComponents"; m.testComponents

  m.list = m.top.FindNode("TestListContent")
  m.list.content = m.testListContent

  m.list.ObserveField("itemSelected", "listItemSelected")

  ' set focus on the Scene (which will set focus on the initialFocus node)
  print "SETTING THE FOCUS"
  m.top.setFocus(true)
  print "AFTER SETTING THE FOCUS"

  print "LABELLIST itemSize"; m.list.itemSize
  print "LABELLIST translation"; m.list.translation
end sub

sub addListItem(label as string, component as string)
   testListItemNode = m.testListContent.createChild("ContentNode")
   testListItemNode.TITLE = label

   m.testComponents.Push(component)
end sub

sub listItemSelected()
  print "in listItemSelected"; m.list
  selectedItem = m.list.itemSelected
  print "-- selected item "; selectedItem

  if (selectedItem >= 0) and (selectedItem < m.testListContent.GetChildCount())
    selectedComponent = m.testComponents.GetEntry(selectedItem)
    print "SelectedComponent is "; selectedComponent
    m.list.visible = false
    m.CurrentTest = CreateObject("RoSGNode", selectedComponent)
    m.CurrentTest.id = "CURRENT_TEST"
    m.top.AppendChild(m.CurrentTest)
    m.CurrentTest.SetFocus(true)
  end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in testList.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      if not (m.CurrentTest = invalid)
        print "CLEANING UP m.CURRENTTEST"
        m.top.RemoveChild(m.CurrentTest)
        m.CurrentTest = invalid

        m.list.visible = true
        m.list.SetFocus(true)
        return true
      end if
    else if key = "home"
      m.top.RemoveChild(m.CurrentTest)
      m.CurrentTest = invalid
    end if
  end if
  return false
end function
