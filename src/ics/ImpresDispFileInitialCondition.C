#include "ImpresDispFileInitialCondition.h"

registerMooseObject("ImpresDispApp", ImpresDispFileInitialCondition);

InputParameters
ImpresDispFileInitialCondition::validParams()
{
  InputParameters params = InitialCondition::validParams();
  params.addRequiredParam<std::string>("file_name",
                                       "The name of the file that contains one variables values");
  return params;
}

ImpresDispFileInitialCondition::ImpresDispFileInitialCondition(const InputParameters & parameters)
  : InitialCondition(parameters), _var_field(getParam<std::string>("file_name"))
{
}

Real
ImpresDispFileInitialCondition::value(const Point & /*p*/)
{
  return _var_field.value(_current_elem->true_centroid());
}
