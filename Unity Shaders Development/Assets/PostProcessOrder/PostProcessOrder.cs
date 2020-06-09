using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PostProcessOrder : MonoBehaviour
{
    [SerializeField]
    private List<Material> PostProcessList = new List<Material>();

    // Update is called once per frame
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        foreach (Material mat in PostProcessList)
        {
            Graphics.Blit(source, destination, mat);
        }
    }
}
