//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "PorousFlowFluidPropertiesBase.h"

class ImpresDispSinglePhaseFluidProperties;

/**
 * General single component fluid material. Provides quadpoint density, viscosity,
 * internal energy, enthalpy and derivatives wrt pressure and temperature
 * for a fluid defined in the FluidProperties module
 */
template <bool is_ad>
class ImpresDispConstantDensityFluidTempl : public PorousFlowFluidPropertiesBaseTempl<is_ad>
{
public:
  static InputParameters validParams();

  ImpresDispConstantDensityFluidTempl(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties() override;
  virtual void computeQpProperties() override;

  /// Fluid properties UserObject
  const ImpresDispSinglePhaseFluidProperties & _fp;

  const MaterialProperty<Real> & _viscosity1;

  usingPorousFlowFluidPropertiesMembers;
};

typedef ImpresDispConstantDensityFluidTempl<false> ImpresDispConstantDensityFluid;
typedef ImpresDispConstantDensityFluidTempl<true> ADImpresDispConstantDensityFluid;
