import React, { useEffect, useState } from 'react'
import styles from './mint.module.scss'


function Mint() {
    useEffect(() => {
        console.log(document.window)
    }, [])
    const [selectedImage, setSelectedImage] = useState(null);

    useEffect(() => {
        let prev = document.querySelector('#preview');
        if (selectedImage) {
            prev.src = URL.createObjectURL(selectedImage);
        }
    }, [selectedImage])

    const [pageState, setpageState] = useState(0);
    const [formState, setform] = useState({ projectName: "", symbol: "", description: "", maxReqFunds: "" });


    const changePage = () => {

        if (Object.values(formState).length < 1) {
            console.log(Object.values(formState).length)
            return alert("Please check all the details");
        }
        let er = false;
        Object.values(formState).forEach((elm) => {
            if (elm.length <= 0) {
                er = true;
            }
        })
        if (er) {
            alert("Please check all the details in the from");
        }
        else {
            setpageState((s) => {
                return s + 1;
            })
        }
    }



    console.log(formState);
    return (
        <div className={styles.main}>
            <div className={styles.dashOutter}>
                <div className={styles.dashInner}>
                    <div className={styles.leftImage}>

                    </div>
                    <div className={styles.rightImage}>
                        {(pageState == 0) && < div className={styles.form}>
                            <h1>Create your Campaign</h1>
                            <label className={styles.input} htmlFor="">
                                <p>Project Name</p>
                                <input type="text" value={formState.projectName} onChange={(e) => {
                                    setform((frm) => {
                                        return { ...frm, projectName: e.target.value }
                                    })
                                }} />
                            </label>
                            <label className={styles.input} htmlFor="">
                                <p>Symbol</p>
                                <input type="text"
                                    value={formState.symbol} onChange={(e) => {
                                        setform((frm) => {
                                            return { ...frm, symbol: e.target.value }
                                        })
                                    }} />
                            </label>
                            <label className={styles.input} htmlFor="">
                                <p>Description</p>
                                <input type="text"
                                    value={formState.description} onChange={(e) => {
                                        setform((frm) => {
                                            return { ...frm, description: e.target.value }
                                        })
                                    }} />
                            </label>
                            <label className={styles.input} htmlFor="">
                                <p>Max Required Funders</p>
                                <input type="text"
                                    value={formState.maxReqFunds} onChange={(e) => {
                                        setform((frm) => {
                                            return { ...frm, maxReqFunds: e.target.value }
                                        })
                                    }} />
                            </label>
                            <button onClick={() => { changePage() }} className={styles.btn}>Next</button>
                        </div>}

                        {(pageState == 1) && <div className={styles.imageUpload}>
                            <h1>Upload Image</h1>
                            <label
                                className={styles.upload}
                                htmlFor="myImage">
                                <input
                                    style={{ position: "absolute" }}
                                    type="file"
                                    name="myImage"
                                    id='myImage'
                                    onChange={(event) => {
                                        console.log(event.target.files[0]);
                                        setSelectedImage(event.target.files[0]);
                                    }}
                                />
                                <img src="/upload.png" alt="" />
                                {(selectedImage) && <img id='preview' src={''} alt="" className={styles.preview} />}
                            </label>

                            <button className={styles.btn}
                                onClick={
                                    () => {
                                        document.querySelector('#myImage').click()
                                    }
                                }
                            >
                                Upload Image
                            </button>
                        </div>}
                    </div>
                </div>
            </div>
        </div >
    )
}

export default Mint