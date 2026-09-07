# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1085. `mix rfd.render` in rfd_dsl/ renders rfd/1085-code-map/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1085 do
  use RFD.DSL

  rfd 1085, "A code map, not a copied API reference" do
    state :published

    scope "the browser client, `src/`"

    attest_in :none

    decision ~S"""
    Replace the reference with a map: name each module group, point at
    its path, and stop. Read the source itself for the current API, not
    a restated signature list. See `DETAILS.md` for the full module
    table, by group: React contexts, scene and rendering, WebXR, avatar
    and traits, export and generation, tasks, wallet and payments,
    hardware bridges, and pages.
    """

    problem ~S"""
    RFD 1018 deleted the M3 API reference this project's client forked:
    seven managers documented, while the real code had grown past
    forty. RFD 1000's own DRY policy forbids a copy of the source, since
    a copy drifts and the source stays correct.
    """

    related ~S"""
    RFD 1018 gives the reason this page exists at all. RFD 1000 gives
    the DRY policy it follows.
    """

    details_title "A code map, not a copied API reference"

    details "React contexts", ~S"""
    Path: `src/context/`
    
    | Context               | Role                                 |
    | --------------------- | ------------------------------------ |
    | `SceneContext.jsx`    | Scene state and the loaded avatar    |
    | `Core3DContext.jsx`   | Renderer, camera, and viewport state |
    | `TaskContext.jsx`     | Task list state for the Task Manager |
    | `AccountContext.jsx`  | Wallet account state                 |
    | `AudioContext.jsx`    | Audio graph and lip-sync input       |
    | `SoundContext.jsx`    | Interface sound effects              |
    | `ViewContext.jsx`     | Active page and view state           |
    | `LanguageContext.jsx` | Interface language                   |
    """

    details "Scene and rendering", ~S"""
    Path: `src/library/`
    
    | Module                  | Role                                    |
    | ----------------------- | --------------------------------------- |
    | `sceneManager.js`       | Three.js scene, camera, and render loop |
    | `effectManager.js`      | Post effects and transitions            |
    | `sharedHDRManager.js`   | Shared environment lighting             |
    | `viewportLighting.js`   | Viewport light and exposure state       |
    | `cameraFrameManager.js` | Camera framing for avatars              |
    | `vrmManager.js`         | VRM load and unload                     |
    | `sparkSplatManager.js`  | Gaussian splat view, through Spark.js   |
    """

    details "WebXR", ~S"""
    Path: `src/library/sceneManagerXr*.js`
    
    The XR code splits by concern, one concern per file: input,
    locomotion, teleport, grab, interaction, menus, axes, controller
    visuals, gamepad buttons, measure, mouse emulation, and the avatar
    view. RFD 1010 (weftspun-3d-studio's own `decisions/`) gives the
    WebXR design.
    """

    details "Avatar and traits", ~S"""
    | Module                   | Role                           |
    | ------------------------ | ------------------------------ |
    | `characterManager.js`    | Avatar assembly and trait swap |
    | `manifestDataManager.js` | Manifest load and trait lookup |
    | `animationManager.js`    | Animation load and playback    |
    | `blinkManager.js`        | Eye blink timing               |
    | `lookatManager.js`       | Head and eye aim               |
    | `EmotionManager.js`      | Expression state               |
    | `assetManager.js`        | Asset fetch and cache          |
    
    RFD 1005 records the avatar and VRM pipeline.
    """

    details "Export and generation", ~S"""
    | Module                     | Role                        |
    | -------------------------- | --------------------------- |
    | `screenshotManager.js`     | Viewport capture            |
    | `thumbnailsGenerator.js`   | Trait thumbnail sheets      |
    | `spriteAtlasGenerator.js`  | Sprite atlas output         |
    | `loraDataGenerator.js`     | LoRA training image sets    |
    | `OverlayTextureManager.js` | Texture overlay composition |
    | `zipManager.js`            | Archive output              |
    | `VRMExporter.js`           | VRM write                   |
    """

    details "Tasks", ~S"""
    | Module               | Role                                      |
    | -------------------- | ----------------------------------------- |
    | `taskManager.js`     | Job submit and poll, against `3DAIGC-API` |
    | `taskPersistence.js` | Task storage in the browser               |
    | `aiModelsCatalog.js` | Task types and model names                |
    
    RFD 1003 records the job lifecycle. RFD 1004 records the task
    catalog.
    """

    details "Wallet and payments", ~S"""
    | Module                   | Role                  |
    | ------------------------ | --------------------- |
    | `solanaManager.js`       | Solana wallet calls   |
    | `baseX402Manager.js`     | Base chain x402 calls |
    | `thirdwebX402Manager.js` | Thirdweb x402 calls   |
    | `vanaDataManager.js`     | Vana data calls       |
    | `mint-utils.js`          | Mint helpers          |
    
    RFD 1012 records the wallet decision. That RFD's own state is
    abandoned.
    """

    details "Hardware bridges", ~S"""
    | Module                 | Role                           |
    | ---------------------- | ------------------------------ |
    | `mbientLabsManager.js` | MbientLab sensor input         |
    | `tapStrapManager.js`   | Tap Strap input                |
    | `nativeFaceBridge.js`  | Android face-bridge interface  |
    | `nativeFaceRelay.js`   | Face data relay to the browser |
    """

    details "Pages", ~S"""
    Path: `src/pages/`
    
    Each page file holds one route. `src/App.jsx` maps the routes. RFD
    1001 records the app shell and the routing.
    """

    drafted_by :ai
  end
end
