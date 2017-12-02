# unityshadersclc
A bunch of Unity Shaders, materials, scripts and scenes based on Catlike Coding Rendering tutorials from here: http://catlikecoding.com/unity/tutorials/rendering. The set includes basic shaders, diffuse, specular and PBS lighting shaders, bump and normal mapping, shadows, etc. Some of them have a few tweaks and modifications and they are all adapted to run on Unity 5.5.1.

# Shaders

* <span></span>**1. Object Position Shader:**
* <span></span>**2. World Position Shader:**
* <span></span>**3. UV Position Shader:**
* <span></span>**4. Simple Texture Shader:**
* <span></span>**5. Simple Texture Detail Shader:**
* <span></span>**6. Binary Texture Splatting Shader:**
* <span></span>**7. Generic Texture Splatting Shader:**
* <span></span>**8. Normal Position Shader:**
* <span></span>**9. Diffuse Shader:**
* <span></span>**10. Diffuse Specular Shader:**
* <span></span>**11. Specular Metallic Shader:**
* <span></span>**12. PBS Shader:**
* <span></span>**13. Diffuse Specular Bump 1D Shader:**
* <span></span>**14. Diffuse Specular Bump 2D FD Shader:**
* <span></span>**15. Diffuse Specular Bump 2D CD Shader:**
* <span></span>**16. Diffuse Specular Normal Map Shader:**
* <span></span>**17. Diffuse Specular Normal Map Detail Shader:**
* <span></span>**18. Diffuse Specular Normal Map Detail WB Shader:**
* <span></span>**19. Diffuse Specular Normal Map Tangent Shader:**
* <span></span>**20. Diffuse Specular NMT Shadow Caster Shader:**
* <span></span>**21. Diffuse Specular NMT Full Shadow Shader:**
* <span></span>**22. Diffuse Specular NMT Full Shadow U Shader:**

# Scenes
The scenes are named following the format *SceneXtoY_Z*, where X represents the lower material ID for which the scene was used to test it, and Y represents the higher material ID for which the scene was used. Z can be either another individual material ID or a range of material IDs in the form XtoY or XtoY_Z.

<img src="https://user-images.githubusercontent.com/5633645/33518743-44c2e90c-d779-11e7-8ef7-c0ab0cee8220.png" alt="scene17" style="max-width:10%" width="640" heigth="480">

<img src="https://user-images.githubusercontent.com/5633645/33518759-7cde7b08-d779-11e7-8c20-8307e144619f.png" alt="scene8_12_19" style="max-width:100%" width="640" heigth="480">

<img src="https://user-images.githubusercontent.com/5633645/33518764-8e395f58-d779-11e7-9d19-a41c2a2ef534.png" alt="scene13_18" style="max-width:100%" width="640" heigth="480">

<img src="https://user-images.githubusercontent.com/5633645/33518766-9de3ebb2-d779-11e7-92a9-2abb7e859413.png" alt="scene20_22" style="max-width:20%" width="640" heigth="480">

# Materials
Materials are created with the same number and name as the corresponding shader. For example:

* <span></span>1. Position Shader Material
* <span></span>2. World Position Shader
* <span></span>10. Specular Shader
* <span></span>12. PBS Shader
* <span></span>21. Diffuse Specular NMT Full Shadow Shader
