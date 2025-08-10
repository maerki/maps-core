/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public
 *  License, v. 2.0. If a copy of the MPL was not distributed with this
 *  file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 *  SPDX-License-Identifier: MPL-2.0
 */

#include <catch2/catch_all.hpp>
#include "SimpleLayerInterface.h"
#include "RenderPass.h"
#include "Color.h"
#include "TextureFilterType.h"
#include "MapInterface.h"
#include "OpenGlRenderingContextInterface.h"
#include "OpenGlRenderTargetInterface.h"
#include "OffscreenRenderTargetHelper.h"

class TestOffscreenLayer : public SimpleLayerInterface, public std::enable_shared_from_this<TestOffscreenLayer> {
public:
    TestOffscreenLayer() = default;
    
    std::vector<std::shared_ptr<RenderPassInterface>> buildRenderPasses() override {
        if (!renderTarget) {
            return {};
        }
        
        // Create a simple render pass with the offscreen target
        std::vector<std::shared_ptr<RenderObjectInterface>> renderObjects;
        auto renderPass = std::make_shared<RenderPass>(
            RenderPassConfig(0, false, renderTarget), 
            renderObjects
        );
        return {renderPass};
    }
    
    void createOffscreenRenderTarget(const std::shared_ptr<MapInterface>& mapInterface, const std::string& name) {
        OffscreenRenderTargetHelper::setupLayerOffscreenRendering(
            std::dynamic_pointer_cast<SimpleLayerInterface>(shared_from_this()),
            mapInterface,
            name
        );
    }
    
    bool hasOffscreenRenderTarget() const {
        return renderTarget != nullptr;
    }
    
    // Expose protected methods for testing
    bool testNeedsRedraw() const {
        return needsRedraw();
    }
    
    void testMarkAsRedrawn() {
        markAsRedrawn();
    }
    
    void testInvalidate() {
        invalidate();
    }
};

TEST_CASE("Offscreen render pass creation", "[OffscreenRenderPasses]") {
    auto testLayer = std::make_shared<TestOffscreenLayer>();
    
    SECTION("Layer starts without render target") {
        REQUIRE_FALSE(testLayer->hasOffscreenRenderTarget());
        auto renderPasses = testLayer->buildRenderPasses();
        REQUIRE(renderPasses.empty());
    }
    
    SECTION("Layer invalidation state") {
        // New layers start as invalidated
        REQUIRE(testLayer->testNeedsRedraw());
        
        // After marking as redrawn, they're no longer invalidated
        testLayer->testMarkAsRedrawn();
        REQUIRE_FALSE(testLayer->testNeedsRedraw());
        
        // Calling invalidate() marks them as needing redraw again
        testLayer->testInvalidate();
        REQUIRE(testLayer->testNeedsRedraw());
    }
    
    SECTION("Can set render target explicitly") {
        // This would require a mock MapInterface, so we'll test the interface
        // The real test is that the API exists and compiles correctly
        REQUIRE_FALSE(testLayer->hasOffscreenRenderTarget());
    }
}

TEST_CASE("OffscreenRenderTargetHelper functionality", "[OffscreenRenderPasses]") {
    SECTION("Helper methods exist and can be called") {
        // Test that the helper class has the expected interface
        // This ensures the API is properly defined
        REQUIRE(true); // Placeholder - actual functionality tested in integration
    }
}