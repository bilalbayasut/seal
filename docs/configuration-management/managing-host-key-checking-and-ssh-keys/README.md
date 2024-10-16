# Managing Host Key Checking and SSH Keys

#### **What is Host Key Checking in SSH?**

**SSH (Secure Shell)** is a tool that lets you securely connect to another computer over a network. To keep this connection safe, SSH uses something called **host keys**.

#### **How Does Host Key Checking Work?**

1. **Remembering Hosts:**
   * Every time you connect to a new computer (or "host") using SSH, it gives your computer a unique identifier called a **host key**.
   * SSH keeps a record of all these host keys in a file located at `~/.ssh/known_hosts` on your computer. Think of this file as a "list of trusted friends."
2. **Checking for Changes:**
   * The next time you try to connect to the same host, SSH checks its current host key against the one stored in your `known_hosts` file.
   * **If the host key matches**, everything is okay, and you can connect safely.
   * **If the host key has changed**, SSH will alert you with a warning.

#### **Why Does SSH Warn About Changed Host Keys?**

* **Security Reasons:**
  * **Preventing Fake Servers:** If someone tries to trick you into connecting to a fake server (a technique called **server spoofing**), the host key wouldn’t match. The warning helps you realize something is wrong.
  * **Stopping Eavesdroppers:** It also protects against **man-in-the-middle attacks**, where an attacker could intercept your connection to steal information or bypass security measures.
* **Disabling Passwords Temporarily:**
  * When there's a mismatch in host keys, SSH may disable password authentication to ensure that your connection remains secure until you verify the host's identity.

#### **Controlling Host Key Checking with SSH Settings**

* **StrictHostKeyChecking:**
  * This is a setting in SSH that lets you decide how strictly SSH should handle unknown or changed host keys.
  * **Options:**
    * **`yes`:** SSH will always check the host key and refuse to connect if it’s not recognized or has changed.
    * **`no`:** SSH will automatically add new host keys to the `known_hosts` file without asking.
    * **`ask`:** SSH will ask you what to do if it encounters a new or changed host key.
* **Why Use It?**
  * By configuring `StrictHostKeyChecking`, you can balance convenience and security based on your needs. For example, in a highly secure environment, you might set it to `yes` to ensure no unauthorized changes go unnoticed.

#### **Summary**

* **SSH** uses **host keys** to verify the identity of the computers you connect to.
* These keys are stored in a file called `known_hosts`.
* If a host’s key changes, SSH warns you to prevent potential security threats like fake servers or attackers intercepting your connection.
* You can control how strict SSH is about these checks using the **StrictHostKeyChecking** setting.

This system helps keep your SSH connections secure by ensuring you’re always connecting to the right computer and not an impostor.
