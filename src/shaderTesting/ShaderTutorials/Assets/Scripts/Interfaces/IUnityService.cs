using UnityEngine;

/* Module name: IUnityService Interface and UnityService Implementation Class
 * Author: Sasha Soraine
 * The purpose of this interface is to separate the UnityEngine Input behaviour from the functionality of the system.
 * This separation is done so as to ease the transition to automated testing.
 * Essentially it is a wrapper for the UnityEngine Input class.
 * Any functionality that requires the Input class should be added here for use.
 */
public interface IUnityService
{
    bool isKeyDown(string key);
}

class UnityService : IUnityService
{
    public bool isKeyDown(string key)
    {
        return Input.GetKeyDown(key);
    }
}