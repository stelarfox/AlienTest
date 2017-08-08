using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameControler : MonoBehaviour {
	private int viewMode; // 1 for normal, 2 for IR, 3 of low dark, 4 for Enhanced enemy, 5 for all at the same time.
	private List<OriginalMats> ChgList;
	// Use this for initialization
	void Start () {
		viewMode = 1;
		Debug.Log ("Starting");
		ChgList= new List<OriginalMats>();

		Material noMaterial= Resources.Load ("IRtoNoneMat", typeof(Material)) as Material;
		if (noMaterial == null) {
			Debug.Log ("Error loading the No Material");
			return;
		}
		Material llMaterial= Resources.Load ("LLMat", typeof(Material)) as Material;
		if (llMaterial == null) {
			Debug.Log ("Error loading the Low Light Material");
			return;
		}
		if (llMaterial.shader == null) {
			Debug.Log ("Error loading the Low Light Material -> no shader on it");
			return;			
		}
//		Shader llShader=llMaterial.shader;

//		Debug.Log(GetComponentsInChildren(Renderer, true).Length.ToString());
		GameObject[] goArray = FindObjectsOfType(typeof(GameObject)) as GameObject[];
		Debug.Log ("Objects Found:" + goArray.Length.ToString());
		foreach (var obj in goArray) {
//			Renderer[] renderers = obj.GetComponentsInChildren<Renderer> ();
//			foreach (var r in renderers) {
			Renderer[] renderers = obj.GetComponentsInChildren<Renderer> ();
			foreach (var r in renderers) {
				GameObject gO = r.gameObject;
				int i;
				for (i = 0; i < r.materials.Length; ++i) {
					string x = r.materials[i].name;
					x = x.Substring (0, x.LastIndexOf (" (Instance"));
					Material newMat = Resources.Load ("Shader_" + x, typeof(Material)) as Material;
					Material newLLMat = new Material (Shader.Find("Custom/LowLight"));
					if (newLLMat == null) {
						Debug.Log ("On go/matnum, could not find shader to create new material:" + gO.name + ":" + i.ToString ());
						return;
					}
					newLLMat.mainTexture = r.materials [i].mainTexture;
					newLLMat.SetColor ("_HiColor", llMaterial.GetColor("_HiColor"));
					newLLMat.SetColor ("_MidColor", llMaterial.GetColor("_MidColor"));
					newLLMat.SetColor ("_LowColor", llMaterial.GetColor("_LowColor"));
					newLLMat.SetFloat ("_MidValue", llMaterial.GetFloat("_MidValue"));


//					if (string.Compare (obj.name, "Guard") == 0) {
//						Debug.Log ("Game Object:" + gO.name);
//						Debug.Log ("Game Material:" + x);
//						if (newMat != null)
//							Debug.Log ("New Material:" + newMat.name);
//					}
					if (newMat == null)
						newMat = noMaterial;
					else {
						if (r.materials [i].mainTexture != null)
							if (newMat.mainTexture == null)
								newMat.mainTexture = r.materials [i].mainTexture;
					}
					ChgList.Add (new OriginalMats (gO, i, r.materials[i], newMat, newLLMat));
				}
			}
		}
		Debug.Log ("If no errors so far great");
//		foreach (var cL in ChgList) {
//			Debug.Log (string.Concat (cL.index,":",  cL.gObj.name,":", cL.subMat,":", cL.mats[0].ToString (),":", cL.mats[1].ToString ()));
//		}
	}
	void Update () {
		if (Input.anyKeyDown) {
			if (Input.GetKeyDown(KeyCode.Alpha1) || Input.GetKeyDown(KeyCode.Keypad1)) {
				ChangeViewMode(1);
			}
			else if(Input.GetKeyDown(KeyCode.Alpha2) || Input.GetKeyDown(KeyCode.Keypad2)) {
				ChangeViewMode(2);
			}
			else if(Input.GetKeyDown(KeyCode.Alpha3) || Input.GetKeyDown(KeyCode.Keypad3)) {
				ChangeViewMode(3);
			}
			else if(Input.GetKeyDown(KeyCode.Alpha4) || Input.GetKeyDown(KeyCode.Keypad4)) {
				ChangeViewMode(4);
			}
			else if(Input.GetKeyDown(KeyCode.Alpha0) || Input.GetKeyDown(KeyCode.Keypad0)) {
				ChangeViewMode(5);
			}
		}
	}
	private void ChangeViewMode(int nMode) {
		if (nMode != viewMode) {
			viewMode = nMode;
			//do the appropiate change into the shader
			Debug.Log("View Mode Changed To:" + viewMode.ToString());
			foreach (var cL in ChgList) {
				cL.SetView (viewMode);
			}
		}
	}
}
