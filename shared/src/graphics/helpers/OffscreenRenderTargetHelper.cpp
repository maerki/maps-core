/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public
 *  License, v. 2.0. If a copy of the MPL was not distributed with this
 *  file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 *  SPDX-License-Identifier: MPL-2.0
 */

#include "OffscreenRenderTargetHelper.h"
#include "SimpleLayerInterface.h"
#include "OpenGlRenderingContextInterface.h"
#include "OpenGlRenderTargetInterface.h"

std::shared_ptr<RenderTargetInterface> OffscreenRenderTargetHelper::createOffscreenRenderTarget(
    const std::shared_ptr<MapInterface>& mapInterface,
    const std::string& layerName,
    const Color& clearColor,
    TextureFilterType textureFilter
) {
    if (!mapInterface) {
        return nullptr;
    }

    auto renderingContext = mapInterface->getRenderingContext();
    if (!renderingContext) {
        return nullptr;
    }

    auto openGlContext = renderingContext->asOpenGlRenderingContext();
    if (!openGlContext) {
        return nullptr;
    }

    auto openGlRenderTarget = openGlContext->getCreateRenderTarget(
        layerName + "_offscreen",
        textureFilter,
        clearColor
    );

    return openGlRenderTarget->asRenderTargetInterface();
}

void OffscreenRenderTargetHelper::setupLayerOffscreenRendering(
    const std::shared_ptr<SimpleLayerInterface>& layer,
    const std::shared_ptr<MapInterface>& mapInterface,
    const std::string& layerName
) {
    if (!layer || !mapInterface) {
        return;
    }

    auto renderTarget = createOffscreenRenderTarget(mapInterface, layerName);
    if (renderTarget) {
        layer->setPrimaryRenderTarget(renderTarget);
    }
}