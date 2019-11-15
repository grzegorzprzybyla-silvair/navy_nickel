//
//  Navy_Nickel-BridgningHeader.h
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

#ifndef Navy_Nickel_BridgningHeader_h
#define Navy_Nickel_BridgningHeader_h

#import "Matrix4.h"
#import <simd/simd.h>

typedef struct {
  matrix_float4x4 modelMatrix;
  matrix_float4x4 viewMatrix;
  matrix_float4x4 projectionMatrix;
} Uniforms;

#endif /* Navy_Nickel_BridgningHeader_h */
