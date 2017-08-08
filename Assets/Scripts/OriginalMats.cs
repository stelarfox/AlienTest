using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OriginalMats : IComparable<OriginalMats> {
	public int index;
	public GameObject gObj;
	public int subMat;
	public Material[] mats;
	static private int num=0;
	private bool isParticle;



	public OriginalMats(GameObject newGO, int newSM, Material newNormal, Material newIR, Material newLL, Material newEnh, int newIndex = -1)
	{
		if (newIndex == -1)
			newIndex = ++num;
		
		index = newIndex;
		gObj = newGO;
		subMat = newSM;

		ParticleSystem[] parSys = gObj.GetComponents<ParticleSystem> ();
		if (parSys.Length == 0) {
			mats = new Material[5];
			isParticle = false;
			mats [0] = newNormal;
			mats [1] = newIR;
			mats [2] = newLL;
			mats [3] = newEnh;
			mats [4] = newNormal;
		} else {
			isParticle = true;
			mats = null;
		}
	}

	//This method is required by the IComparable
	//interface. 
	public int CompareTo(OriginalMats other)
	{
		if (other == null)
			return 1;
		return index - other.index;
	}
	public void SetView(int view) {
		if (view > 0 && view < 6) {// can't allow more views
			if (isParticle) {
				gObj.SetActive (view == 1 || view == 5);
			} else {
				if (subMat == 0)
					gObj.GetComponent<Renderer> ().material = mats [view - 1];
				Material[] auxMat = gObj.GetComponent<Renderer> ().materials;
				auxMat [subMat] = mats [view - 1];
				gObj.GetComponent<Renderer> ().materials = auxMat;
			}
		}
	}
}
