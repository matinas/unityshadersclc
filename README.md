# unityshadersclc
A bunch of Unity shaders, materials, scripts and scenes based on Catlike Coding Rendering tutorials by Jasper Flick from here: http://catlikecoding.com/unity/tutorials/rendering. The set includes basic shaders, diffuse, specular and PBS lighting shaders, bump and normal mapping, shadow rendering, etc. Some of them have a few tweaks and modifications and they are all adapted to run on Unity 5.5.1.

# Shaders

* <span></span>**1. Object Position Shader:** shades an object based on each fragment's position (object space). Based on "Shader Fundamentals" tutorial. 

   <img src="https://user-images.githubusercontent.com/5633645/33520423-5bb4c3e0-d799-11e7-9b00-8f5d1222b9d5.png" alt="scene1to7_2" style="max-width:100%" width="256" heigth="256">

* <span></span>**2. World Position Shader:** shades an object based on each fragment's position (world space). Based on "Shader Fundamentals" tutorial.

* <span></span>**3. UV Position Shader:** shades an object based on each fragment's uv position. Based on "Shader Fundamentals" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33520424-5bd5fab0-d799-11e7-9058-7af1f54a170f.png" alt="scene1to7_3" style="max-width:100%" width="256" heigth="256">

* <span></span>**4. Simple Texture Shader:** shades an object using a given texture. Based on "Shader Fundamentals" tutorial.

* <span></span>**5. Simple Texture Detail Shader:** shades an object combining two given textures, a main texture and a detail texture used to add detail to the former. Based on "Combining Textures" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33520425-5bf7370c-d799-11e7-9d41-ed7b9f03cbd3.png" alt="scene1to7_4" style="max-width:100%" width="640" heigth="480">

* <span></span>**6. Binary Texture Splatting Shader:** shades an object combining two given textures, using a splat map to decide where in the object each texture applies. Based on "Combining Textures" tutorial.

* <span></span>**7. Generic Texture Splatting Shader:** shades an object combining four given textures, using a splat map to decide where in the object each texture applies. Based on "Combining Textures" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33518743-44c2e90c-d779-11e7-8ef7-c0ab0cee8220.png" alt="scene17" style="max-width:10%" width="640" heigth="480">

* <span></span>**8. Normal Position Shader:** shades an object based on each fragment normal's position (in world space). Based on "The First Light" tutorial.

* <span></span>**9. Diffuse Shader:** shades an object based on the diffuse light it receives from an only directional light, including object's Albedo color. Based on "The First Light" tutorial.

* <span></span>**10. Diffuse Specular Shader:** shades an object based on the diffuse and specular light it receives from an only directional light (Blinn-Phong shading taking care of energy conservation), including object's Albedo color and Specular color. Based on "The First Light" tutorial.

* <span></span>**11. Specular Metallic Shader:** shades an object based on the diffuse and specular light it receives from an only directional light (Blinn-Phong shading considering the Metallic workflow), including object's Albedo color and Specular color. Based on "The First Light" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33520296-e0e0e09c-d796-11e7-92ff-71bc0f495ad1.png" alt="scene8_12" style="max-width:100%" width="640" heigth="480">

* <span></span>**12. PBS Shader:** shades an object based on the PBR (Physically Based Shading) algorithm provided by Unity. Based on "The First Light" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33520422-5b92fef4-d799-11e7-839e-b65ec9964fb0.png" alt="scene1to7_5" style="max-width:100%" width="256" heigth="256">

* <span></span>**13. Diffuse Specular Bump 1D Shader:** shades an object applying Bump Mapping in 1D (Finite-Difference) based on a given greyscale height map. Based on "Bumpiness" tutorial.

* <span></span>**14. Diffuse Specular Bump 2D FD Shader:** shades an object applying Bump Mapping in 2D (Finite Difference) based on a given greyscale height map. Based on "Bumpiness" tutorial.

* <span></span>**15. Diffuse Specular Bump 2D CD Shader:** shades an object applying Bump Mapping in 2D (Central Difference) based on a given greyscale height map. Based on "Bumpiness" tutorial.

* <span></span>**16. Diffuse Specular Normal Map Shader:** shades an object based on an Albedo texture and a Normal Map used to calculate bumpiness (does not consider Tangent Space). Based on "Bumpiness" tutorial.

* <span></span>**17. Diffuse Specular Normal Map Detail Shader:** shades an object based on a main texture, a detail texture and its corresponding Normal Maps used to calculate bumpiness as an average of each normal. Based on "Bumpiness" tutorial.

* <span></span>**18. Diffuse Specular Normal Map Detail WB Shader:** shades an object based on a main texture, a detail texture and its corresponding Normal Maps used to calculate bumpiness as an average of each normal (with whiteout blending). Based on "Bumpiness" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33518764-8e395f58-d779-11e7-9d19-a41c2a2ef534.png" alt="scene13_18" style="max-width:100%" width="640" heigth="480">

* <span></span>**19. Diffuse Specular Normal Map Tangent Shader:** shades an object based on an Albedo texture and a Normal Map used to calculate bumpiness, considering Tangent Space. Based on "Bumpiness" tutorial.

* <span></span>**20. Diffuse Specular NMT Shadow Caster Shader:** shades an object based on an Albedo texture and a Normal Map used to calculate bumpiness (Tangent Space) and cast shadows to another objects coming from two Directional lights. Based on "Shadows" tutorial.

* <span></span>**21. Diffuse Specular NMT Full Shadow Shader:** shades an object based on an Albedo texture and a Normal Map used to calculate bumpiness (Tangent Space) and cast shadows to and receives shadows from another objects, considering only two Directional lights. Based on "Shadows" tutorial.

* <span></span>**22. Diffuse Specular NMT Full Shadow U Shader:** same as #21 but using Unity native functions and macros for receiving shadows. Based on "Shadows" tutorial.

   <img src="https://user-images.githubusercontent.com/5633645/33520298-ed8c6e24-d796-11e7-8fbe-8ae0c8c3d851.png" alt="scene20_22" style="max-width:100%" width="640" heigth="480">

# Scenes
The scenes are named following the format *SceneXtoY_Z*, where X represents the lower material ID for which the scene was used to test it, and Y represents the higher material ID for which the scene was used. Z can be either another individual material ID or a range of material IDs in the form XtoY or XtoY_Z.

# Materials
Materials are created with the same number and name as the corresponding shader.
