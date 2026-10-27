

#pragma once

#include "InitialCondition.h"
#include "ImpresDispGridField.h"

class InputParameters;
class ImpresDispFileInitialCondition;
namespace libMesh
{
class Point;
}

class ImpresDispFileInitialCondition : public InitialCondition
{
public:
  static InputParameters validParams();

  ImpresDispFileInitialCondition(const InputParameters & parameters);
  virtual Real value(const Point & p) override;

private:
  ImpresDispGridField _var_field;
};
