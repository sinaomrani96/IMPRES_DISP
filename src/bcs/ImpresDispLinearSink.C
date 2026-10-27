//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ImpresDispLinearSink.h"

registerMooseObject("ImpresDispApp", ImpresDispLinearSink);

InputParameters
ImpresDispLinearSink::validParams()
{
  InputParameters params = ImpresDispSinkPTDefiner::validParams();
  params.addRequiredParam<std::vector<Real>>(
      "pt_vals",
      "Tuple of pressure values (for the fluid_phase specified).  Must be monotonically "
      "increasing.  For heat fluxes that don't involve fluids, these are temperature "
      "values");
  params.addRequiredParam<std::vector<Real>>(
      "multipliers", "Tuple of multiplying values.  The flux values are multiplied by these.");
  params.addClassDescription("Applies a flux sink to a boundary. The base flux defined by "
                             "ImpresDispSink is multiplied by a piecewise linear function.");
  return params;
}

ImpresDispLinearSink::ImpresDispLinearSink(const InputParameters & parameters)
  : ImpresDispSinkPTDefiner(parameters),
    _sink_func(getParam<std::vector<Real>>("pt_vals"), getParam<std::vector<Real>>("multipliers"))
{
}

Real
ImpresDispLinearSink::multiplier() const
{
  return ImpresDispSink::multiplier() * _sink_func.sample(ptVar());
}

Real
ImpresDispLinearSink::dmultiplier_dvar(unsigned int pvar) const
{
  return ImpresDispSink::dmultiplier_dvar(pvar) * _sink_func.sample(ptVar()) +
         ImpresDispSink::multiplier() * _sink_func.sampleDerivative(ptVar()) * dptVar(pvar);
}
