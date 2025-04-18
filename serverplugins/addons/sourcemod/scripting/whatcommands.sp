#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{
    name = "[ANY] PlayerAvailable Commands",
    author = "Aster",
    description = "Display command information",
    version = SOURCEMOD_VERSION,
    url = "http://www.sourcemod.net/"
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_commands", HelpCmd, "Displays SourceMod commands and descriptions in a menu");
}

public Action HelpCmd(int client, int args)
{
    Menu menu = CreateMenu(Menu_Commands);
    menu.SetTitle("SM help commands\n ");

    char Name[64], Desc[255], NoDesc[128];
    int Flags;
    Handle CmdIter = GetCommandIterator();

    FormatEx(NoDesc, sizeof(NoDesc), "No description");
    
    for (int i = 0; ReadCommandIterator(CmdIter, Name, sizeof(Name), Flags, Desc, sizeof(Desc)); i++)
    {
        if (CheckCommandAccess(client, Name, Flags))
        {
            char strDisplay[56];    //512 / 9
            Format(strDisplay, sizeof(strDisplay), "%s - %s", Name, (Desc[0] == '\0') ? NoDesc : Desc);
            menu.AddItem("", strDisplay, ITEMDRAW_DISABLED);
        }
    }
    
    menu.ExitButton = true;
    menu.Display(client, MENU_TIME_FOREVER);

    delete CmdIter;

    return Plugin_Handled;
}

public int Menu_Commands(Handle menu, MenuAction action, int client, int option)
{
    if(action == MenuAction_End)
    {
        CloseHandle(menu);
    }
}  