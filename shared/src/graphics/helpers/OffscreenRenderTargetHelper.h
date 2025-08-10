/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public
 *  License, v. 2.0. If a copy of the MPL was not distributed with this
 *  file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 *  SPDX-License-Identifier: MPL-2.0
 */

#pragma once

#include "RenderTargetInterface.h"
#include "MapInterface.h"
#include "Color.h"
#include "TextureFilterType.h"
#include <memory>
#include <string>

class OffscreenRenderTargetHelper {
public:
    /**
     * Creates an offscreen render target for a layer
     * @param mapInterface The map interface to get rendering context from
     * @param layerName Name of the layer (used for render target naming)
     * @param clearColor Clear color for the render target (default: transparent)
     * @param textureFilter Texture filtering type (default: LINEAR)
     * @return Shared pointer to the created render target interface, or nullptr if creation failed
     */
    static std::shared_ptr<RenderTargetInterface> createOffscreenRenderTarget(
        const std::shared_ptr<MapInterface>& mapInterface,
        const std::string& layerName,
        const Color& clearColor = Color(0.0f, 0.0f, 0.0f, 0.0f),
        TextureFilterType textureFilter = TextureFilterType::LINEAR
    );

    /**
     * Helper method to set up offscreen rendering for a layer
     * @param layer The layer to set up offscreen rendering for
     * @param mapInterface The map interface
     * @param layerName Name for the render target
     */
    static void setupLayerOffscreenRendering(
        const std::shared_ptr<SimpleLayerInterface>& layer,
        const std::shared_ptr<MapInterface>& mapInterface,
        const std::string& layerName
    );
};