//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "ImpresDispTestApp.h"
#include "ImpresDispApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
ImpresDispTestApp::validParams()
{
  InputParameters params = ImpresDispApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

ImpresDispTestApp::ImpresDispTestApp(const InputParameters & parameters) : MooseApp(parameters)
{
  ImpresDispTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

ImpresDispTestApp::~ImpresDispTestApp() {}

void
ImpresDispTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  ImpresDispApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"ImpresDispTestApp"});
    Registry::registerActionsTo(af, {"ImpresDispTestApp"});
  }
}

void
ImpresDispTestApp::registerApps()
{
  registerApp(ImpresDispApp);
  registerApp(ImpresDispTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
ImpresDispTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ImpresDispTestApp::registerAll(f, af, s);
}
extern "C" void
ImpresDispTestApp__registerApps()
{
  ImpresDispTestApp::registerApps();
}
