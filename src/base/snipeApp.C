// Local Includes
#include "snipeApp.h"

// MOOSE Includes
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

/*******************************************************************************
Input template (do NOT touch)
*******************************************************************************/
template <>
InputParameters
validParams<snipeApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

/*******************************************************************************
Routine: SnipeApp -- constructor
*******************************************************************************/

snipeApp::snipeApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  snipeApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  snipeApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  snipeApp::registerExecFlags(_factory);
}

snipeApp::~snipeApp() {}

void
snipeApp::registerApps()
{
  registerApp(snipeApp);
}

void
snipeApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"snipeApp"});
}

void
snipeApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"snipeApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
snipeApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
snipeApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
snipeApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
snipeApp__registerApps()
{
  snipeApp::registerApps();
}

/*******************************************************************************
Routine: registerObjects
*******************************************************************************/
extern "C" void
snipeApp__registerObjects(Factory & factory)
{
  snipeApp::registerObjects(factory);
}

/*******************************************************************************
Routine: registerApps
*******************************************************************************/
extern "C" void
snipeApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  snipeApp::associateSyntax(syntax, action_factory);
}

extern "C" void
snipeApp__registerExecFlags(Factory & factory)
{
  snipeApp::registerExecFlags(factory);
}
