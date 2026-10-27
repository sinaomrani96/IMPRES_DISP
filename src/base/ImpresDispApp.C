#include "ImpresDispApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
ImpresDispApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

ImpresDispApp::ImpresDispApp(const InputParameters & parameters) : MooseApp(parameters)
{
  ImpresDispApp::registerAll(_factory, _action_factory, _syntax);
}

ImpresDispApp::~ImpresDispApp() {}

void
ImpresDispApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<ImpresDispApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"ImpresDispApp"});
  Registry::registerActionsTo(af, {"ImpresDispApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
ImpresDispApp::registerApps()
{
  registerApp(ImpresDispApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
ImpresDispApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ImpresDispApp::registerAll(f, af, s);
}
extern "C" void
ImpresDispApp__registerApps()
{
  ImpresDispApp::registerApps();
}
