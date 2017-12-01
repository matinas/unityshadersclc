using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TangentSpaceVisualizer : MonoBehaviour {

	public float scale = 1.0f;
	public float offset = 0.01f;

	void OnDrawGizmos () {

		MeshFilter filter = GetComponent<MeshFilter>();
		if (filter) {
			Mesh mesh = filter.sharedMesh;
			if (mesh) {
				ShowTangentSpace(mesh);
			}
		}
	}

	void ShowTangentSpace (Mesh mesh) {

		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		Vector4[] tangents = mesh.tangents;

		for (int i = 0; i < vertices.Length; i++)
			ShowTangentSpace(transform.TransformPoint(vertices[i]),
							 transform.TransformDirection(normals[i]),
							 transform.TransformDirection(tangents[i]),
							 transform.TransformDirection(Vector3.Cross(normals[i],tangents[i]) * tangents[i].w)); // Binormal sign is given by tangent's w coord
	}

	void ShowTangentSpace (Vector3 vertex, Vector3 normal, Vector3 tangent, Vector3 binormal) {

		vertex = vertex + normal*offset;

		// Draw normal
		Gizmos.color = Color.green;
		Gizmos.DrawLine(vertex, vertex + normal*scale);

		// Draw tangent
		Gizmos.color = Color.red;
		Gizmos.DrawLine(vertex, vertex + tangent*scale);

		// Draw binormal
		Gizmos.color = Color.blue;
		Gizmos.DrawLine(vertex, vertex + binormal*scale);
	}
}
