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

class m8f_os_Query
{

  // public: ///////////////////////////////////////////////////////////////////

  static m8f_os_Query fromString(string str)
  {
    let query = new("m8f_os_Query");
    str.Split(query.mQueryParts, " ", TOK_SKIPEMPTY);
    return query;
  }

  bool matches(string text)
  {
    bool isSearchForAny = CVar.GetCVar("m8f_os_is_any_of").GetBool();

    return isSearchForAny
      ? matchesAny(text)
      : matchesAll(text);
  }

  // private: //////////////////////////////////////////////////////////////////

  private bool matchesAny(string text)
  {
    int nParts = mQueryParts.size();

    for (int i = 0; i < nParts; ++i)
    {
      string queryPart = mQueryParts[i];

      if (contains(text, queryPart))
      {
        return true;
      }
    }

    return false;
  }

  private bool matchesAll(string text)
  {
    int nParts = mQueryParts.size();

    for (int i = 0; i < nParts; ++i)
    {
      string queryPart = mQueryParts[i];

      if (!contains(text, queryPart))
      {
        return false;
      }
    }

    return true;
  }

  private static bool contains(string str, string substr)
  {
    str   .toLower();
    substr.toLower();

    bool contains = (str.IndexOf(substr) != -1);

    return contains;
  }

  // private: //////////////////////////////////////////////////////////////////

  private Array<String> mQueryParts;

} // m8f_os_Query
