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

	public OriginalMats(GameObject newGO, int newSM, Material newNormal, Material newIR, int newIndex = -1)
	{
		if (newIndex == -1)
			newIndex = ++num;
		
		index = newIndex;
		gObj = newGO;
		subMat = newSM;
		mats = new Material[5];

		mats [0] = newNormal;
		mats [1] = newIR;
		mats [2] = newNormal;
		mats [3] = newNormal;
		mats [4] = newNormal;
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
			if (subMat == 0)
				gObj.GetComponent<Renderer> ().material = mats [view - 1];
			Material[] auxMat = gObj.GetComponent<Renderer> ().materials;
			auxMat[subMat]=mats [view - 1];
			gObj.GetComponent<Renderer> ().materials = auxMat;
		}
	}
}
