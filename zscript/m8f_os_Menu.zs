//-----------------------------------------------------------------------------
//
// Copyright 2019 m8f (Alexander Kromm)
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/
//
//-----------------------------------------------------------------------------

class m8f_os_Menu : OptionMenu
{

  // public: ///////////////////////////////////////////////////////////////////

  override void Init(Menu parent, OptionMenuDescriptor desc)
  {
    Super.Init(parent, desc);

    CVar.GetCVar("m8f_os_query").SetString("");

    mDesc.mItems.clear();

    addSearchField();

    mDesc.mScrollPos    = 0;
    mDesc.mSelectedItem = 0;
    mDesc.CalcIndent();
  }

  // public: ///////////////////////////////////////////////////////////////////

  void search(m8f_os_Query query)
  {
    mDesc.mItems.clear();

    addSearchField();

    string path  = StringTable.Localize("$OPTMNU_TITLE");
    bool   found = listOptions("MainMenu", query, path);

    if (!found)
    {
      string noResults = StringTable.Localize("$M8F_OS_NO_RESULTS");
      let    text      = new("OptionMenuItemStaticText").Init(noResults, 0);
      addEmptyLine(mDesc);
      mDesc.mItems.push(text);
    }

    mDesc.CalcIndent();
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_os_SearchField addSearchField()
  {
    string searchLabel = StringTable.Localize("$M8F_OS_LABEL");
    let    searchField = new("m8f_os_SearchField").Init(searchLabel, self);
    mDesc.mItems.push(searchField);

    let anyAllOption = new("OptionMenuItemOption").Init("", "m8f_os_is_any_of", "m8f_os_is_any_of_values");
    mDesc.mItems.push(anyAllOption);

    addEmptyLine(mDesc);

    return searchField;
  }

  private bool listOptions(string menuName, m8f_os_Query query, string path)
  {
    let desc = MenuDescriptor.GetDescriptor(menuName);

    let listMenu = ListMenuDescriptor(desc);
    if (listMenu)
    {
      return listOptionsListMenu(listMenu, query, path);
    }

    let optionMenu = OptionMenuDescriptor(desc);
    if (optionMenu)
    {
      return listOptionsOptionMenu(optionMenu, query, path);
    }

    return false;
  }

  private bool listOptionsListMenu(ListMenuDescriptor desc, m8f_os_Query query, string path)
  {
    int  nItems = desc.mItems.size();
    bool found  = false;

    for (int i = 0; i < nItems; ++i)
    {
      let    item    = desc.mItems[i];
      string actionN = item.GetAction();
      string newPath = (actionN == "Optionsmenu")
        ? StringTable.Localize("$OPTMNU_TITLE")
        : StringTable.Localize("$M8F_OS_MAIN");

      found |= listOptions(actionN, query, newPath);
    }

    return found;
  }

  private bool listOptionsOptionMenu(OptionMenuDescriptor desc, m8f_os_Query query, string path)
  {
    if (desc == mDesc) { return false; }

    int  nItems = desc.mItems.size();
    bool first  = true;
    bool found  = false;

    for (int i = 0; i < nItems; ++i)
    {
      let item = desc.mItems[i];

      if (item is "OptionMenuItemStaticText") { continue; }

      string label = StringTable.Localize(item.mLabel);

      if (query.matches(label))
      {
        found = true;

        if (first)
        {
          addEmptyLine(mDesc);
          addPathItem(mDesc, path);
          first = false;
        }

        let itemOptionBase = OptionMenuItemOptionBase(item);
        if (itemOptionBase)
        {
          itemOptionBase.mCenter = false;
        }

        mDesc.mItems.push(item);
      }
    }

    for (int i = 0; i < nItems; ++i)
    {
      let    item  = desc.mItems[i];
      string label = StringTable.Localize(item.mLabel);

      string optionSearchTitle = StringTable.Localize("$M8F_OS_TITLE");
      if (label == optionSearchTitle) { continue; }

      if (item is "OptionMenuItemSubMenu")
      {
        string newPath = makePath(path, label);
        found |= listOptions(item.GetAction(), query, newPath);
      }
    }

    return found;
  }

  // private: //////////////////////////////////////////////////////////////////

  private static string makePath(string path, string label)
  {
    int    pathWidth   = SmallFont.StringWidth(path .. "/" .. label);
    int    screenWidth = Screen.GetWidth();
    bool   isTooWide   = (pathWidth > screenWidth / 3);
    string newPath     = isTooWide
      ? path .. "/" .. "\n" .. label
      : path .. "/" ..         label;

    return newPath;
  }

  private void addPathItem(OptionMenuDescriptor desc, string path)
  {
    Array<String> lines;
    path.split(lines, "\n");
    int nLines = lines.size();

    for (int i = 0; i < nLines; ++i)
    {
      OptionMenuItemStaticText text = new("OptionMenuItemStaticText").Init(lines[i], 1);

      mDesc.mItems.push(text);
    }
  }

  private static void addEmptyLine(OptionMenuDescriptor desc)
  {
    int nItems = desc.mItems.size();
    if (nItems > 0)
    {
      let staticText = OptionMenuItemStaticText(desc.mItems[nItems - 1]);
      if (staticText != null && staticText.mLabel == "") { return; }
    }

    let item = new("OptionMenuItemStaticText").Init("");
    desc.mItems.push(item);
  }

} // m8f_os_Menu
