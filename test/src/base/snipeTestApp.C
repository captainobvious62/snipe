//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "snipeTestApp.h"
#include "snipeApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<snipeTestApp>()
{
  InputParameters params = validParams<snipeApp>();
  return params;
}

snipeTestApp::snipeTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  snipeApp::registerObjectDepends(_factory);
  snipeApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  snipeApp::associateSyntaxDepends(_syntax, _action_factory);
  snipeApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  snipeApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    snipeTestApp::registerObjects(_factory);
    snipeTestApp::associateSyntax(_syntax, _action_factory);
    snipeTestApp::registerExecFlags(_factory);
  }
}

snipeTestApp::~snipeTestApp() {}

void
snipeTestApp::registerApps()
{
  registerApp(snipeApp);
  registerApp(snipeTestApp);
}

void
snipeTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
snipeTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
snipeTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
snipeTestApp__registerApps()
{
  snipeTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
snipeTestApp__registerObjects(Factory & factory)
{
  snipeTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
snipeTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  snipeTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
snipeTestApp__registerExecFlags(Factory & factory)
{
  snipeTestApp::registerExecFlags(factory);
}
