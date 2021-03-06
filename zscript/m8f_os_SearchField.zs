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

class m8f_os_SearchField : OptionMenuItemTextField
{

  // public: ///////////////////////////////////////////////////////////////////

  m8f_os_SearchField Init(String label, m8f_os_Menu menu)
  {
    Super.Init(label, "");
    mCVar = CVar.GetCVar("m8f_os_query");
    mMenu = menu;

    return self;
  }

  // public: ///////////////////////////////////////////////////////////////////

  override bool MenuEvent(int mkey, bool fromcontroller)
  {
    if (mkey == Menu.MKEY_Input)
    {
      string text  = mEnter.GetText();
      let    query = m8f_os_Query.fromString(text);

      mMenu.search(query);
    }

    return Super.MenuEvent(mkey, fromcontroller);
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_os_Menu mMenu;

} // class m8f_os_SearchField
